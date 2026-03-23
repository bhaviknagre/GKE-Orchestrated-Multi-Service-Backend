output "services_enabled" {
  value = [
    google_project_service.compute_api.service,
    google_project_service.container_api.service,
    google_project_service.artifact_registry_api.service,
    google_project_service.cloudsql_api.service,
    google_project_service.service_networking_api.service,
    google_project_service.secret_manager_api.service,
    google_project_service.cloudbuild_api.service,
    google_project_service.monitoring_api.service,
    google_project_service.logging_api.service,
    google_project_service.iam_credentials_api.service,
  ]
}