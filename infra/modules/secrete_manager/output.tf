output "secret_name" {
  value = google_secret_manager_secret.db_password.secret_id
}

output "gke_service_account_email" {
  value = google_service_account.gke_sa.email
}