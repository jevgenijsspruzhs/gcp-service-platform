locals {
  name  = "${var.service_name}-${var.environment}"
  image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.images.repository_id}/${var.service_name}:${var.image_tag}"
}

locals {
  standard_labels = {
    team        = "inventory"
    environment = var.environment
    managed-by  = "terraform"
    cost-center = var.cost_center
  }
}

resource "google_artifact_registry_repository" "images" {
  location      = var.region
  repository_id = local.name
  description   = "Container images of ${local.name}."
  format        = "DOCKER"
  labels        = local.standard_labels
}

resource "google_storage_bucket" "data" {
  name     = "${var.project_id}-${local.name}-data"
  location = var.region

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  labels                      = local.standard_labels

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5
    }
    action {
      type = "Delete"
    }
  }
}

module "runtime_identity" {
  source = "./modules/service-account"

  project_id   = var.project_id
  account_id   = local.name
  display_name = "Runtime identity of ${local.name}"

  project_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ]
}

resource "google_storage_bucket_iam_member" "runtime_data" {
  bucket = google_storage_bucket.data.name
  role   = "roles/storage.objectAdmin"
  member = module.runtime_identity.member
}

resource "google_artifact_registry_repository_iam_member" "runtime_pull" {
  location   = google_artifact_registry_repository.images.location
  repository = google_artifact_registry_repository.images.name
  role       = "roles/artifactregistry.reader"
  member     = module.runtime_identity.member
}

resource "google_cloud_run_v2_service" "api" {
  name     = local.name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  labels   = local.standard_labels

  template {
    service_account = module.runtime_identity.email

    scaling {
      min_instance_count = var.min_instances
    }

    containers {
      image = local.image

      env {
        name  = "DATA_BUCKET"
        value = google_storage_bucket.data.name
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_artifact_registry_repository_iam_member.runtime_pull]
}
