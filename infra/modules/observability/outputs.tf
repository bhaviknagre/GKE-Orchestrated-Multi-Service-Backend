output "email_notification_channel_id" {
  value       = google_monitoring_notification_channel.email.id
  description = "Email notification channel ID"
}

output "slack_notification_channel_id" {
  value       = google_monitoring_notification_channel.slack.id
  description = "Slack notification channel ID"
}

output "cpu_alert_policy_id" {
  value       = google_monitoring_alert_policy.cpu_high.id
  description = "CPU alert policy ID"
}

output "memory_alert_policy_id" {
  value       = google_monitoring_alert_policy.memory_high.id
  description = "Memory alert policy ID"
}

output "slo_id" {
  value       = google_monitoring_slo.order_availability.id
  description = "Order service SLO ID"
}