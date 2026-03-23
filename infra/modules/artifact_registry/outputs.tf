output "repository_name" {
  value       = google_artifact_registry_repository.repo.repository_id
  description = "Name of the Artifact Registry repository"
}

output "repository_url" {
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}"
  description = "Full URL of the Artifact Registry repository"
}
