output "email" {
  description = "The service account's email address."
  value       = google_service_account.this.email
}

output "member" {
  description = "The service account as an IAM member (serviceAccount:EMAIL)."
  value       = "serviceAccount:${google_service_account.this.email}"
}
