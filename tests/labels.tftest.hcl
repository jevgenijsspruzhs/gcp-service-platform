mock_provider "google" {}

variables {
  project_id  = "acme-platform-dev"
  environment = "dev"
  cost_center = "cc-4100"
}

run "cost_center_accepts_well_formed_value" {
  command = plan

  assert {
    condition     = var.cost_center == "cc-4100"
    error_message = "cc-4100 must be accepted as a cost_center."
  }
}

run "cost_center_rejects_short_number" {
  command = plan

  variables {
    cost_center = "cc-41"
  }

  expect_failures = [var.cost_center]
}

run "cost_center_rejects_bare_number" {
  command = plan

  variables {
    cost_center = "4100"
  }

  expect_failures = [var.cost_center]
}

run "cost_center_rejects_long_number" {
  command = plan

  variables {
    cost_center = "cc-41000"
  }

  expect_failures = [var.cost_center]
}

run "labels_on_dev_resources" {
  command = plan

  assert {
    condition     = google_artifact_registry_repository.images.labels == { team = "inventory", environment = "dev", managed-by = "terraform", cost-center = "cc-4100" }
    error_message = "The image repository must carry the standard labels."
  }

  assert {
    condition     = google_storage_bucket.data.labels == { team = "inventory", environment = "dev", managed-by = "terraform", cost-center = "cc-4100" }
    error_message = "The data bucket must carry the standard labels."
  }

  assert {
    condition     = google_cloud_run_v2_service.api.labels == { team = "inventory", environment = "dev", managed-by = "terraform", cost-center = "cc-4100" }
    error_message = "The Cloud Run service must carry the standard labels."
  }
}

run "labels_follow_environment_and_cost_center" {
  command = plan

  variables {
    project_id  = "acme-platform-prod"
    environment = "prod"
    cost_center = "cc-4200"
  }

  assert {
    condition     = google_cloud_run_v2_service.api.labels == { team = "inventory", environment = "prod", managed-by = "terraform", cost-center = "cc-4200" }
    error_message = "The labels must take the environment and cost_center values."
  }
}
