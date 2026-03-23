variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "location" {
  type        = string
  description = "Region for secret replication"
}

variable "secret_id" {
  type        = string
  description = "Secret Manager secret ID"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password to store in Secret Manager"
}

variable "gke_sa_account_id" {
  type        = string
  description = "Service account ID for GKE workload identity"
}

variable "gke_sa_display_name" {
  type        = string
  description = "Display name for GKE workload identity service account"
}