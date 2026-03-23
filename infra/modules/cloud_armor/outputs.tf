output "cloud_armor_policy_name" {
  value       = google_compute_security_policy.waf_policy.name
  description = "Name of the Cloud Armor WAF policy"
}

output "cloud_armor_policy_id" {
  value       = google_compute_security_policy.waf_policy.id
  description = "ID of the Cloud Armor WAF policy"
}

output "backend_service_id" {
  value       = google_compute_backend_service.order_service_backend.id
  description = "ID of the backend service"
}

output "health_check_id" {
  value       = google_compute_health_check.order_service_hc.id
  description = "ID of the health check"
}