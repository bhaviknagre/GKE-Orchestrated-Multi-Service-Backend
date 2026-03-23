resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = var.secret_id

  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}

resource "google_service_account" "gke_sa" {
  project      = var.project_id
  account_id   = var.gke_sa_account_id
  display_name = var.gke_sa_display_name
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.gke_sa.email}"

  depends_on = [
    google_secret_manager_secret.db_password,
    google_service_account.gke_sa
  ]
}