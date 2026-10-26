output "service_url" {
  description = "The service's URL (internal ingress only)."
  value       = google_cloud_run_v2_service.api.uri
}

output "data_bucket" {
  description = "The name of the service's data bucket."
  value       = google_storage_bucket.data.name
}

output "image_repository" {
  description = "Where the service's container images are pushed."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.images.repository_id}"
}

output "runtime_service_account" {
  description = "The service account the service runs as."
  value       = module.runtime_identity.email
}
