variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "alert_email" {
  type        = string
  description = "Email address for critical alerts"
}

variable "slack_webhook_url" {
  type        = string
  sensitive   = true
  description = "Slack webhook URL for alerts"
}

variable "service_name" {
  type        = string
  description = "Service ID used in monitoring and filters"
}

variable "service_display_name" {
  type        = string
  description = "Display name for the monitored service"
}

variable "metric_name" {
  type        = string
  description = "Name of the log-based metric for 5xx errors"
  default     = "app_5xx_errors"
}

variable "cpu_threshold" {
  type        = number
  description = "CPU usage threshold (0-1)"
  default     = 0.8
}

variable "memory_threshold" {
  type        = number
  description = "Memory usage threshold in bytes"
  default     = 524288000
}

variable "pod_restart_threshold" {
  type        = number
  description = "Pod restart count threshold"
  default     = 3
}

variable "error_rate_threshold" {
  type        = number
  description = "5xx error rate warning threshold"
  default     = 2
}

variable "slo_burn_threshold" {
  type        = number
  description = "5xx error rate critical threshold"
  default     = 10
}

variable "slo_goal" {
  type        = number
  description = "SLO availability goal (0-1)"
  default     = 0.995
}