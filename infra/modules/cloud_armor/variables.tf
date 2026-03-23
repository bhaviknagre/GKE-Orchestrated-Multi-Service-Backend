variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "policy_name" {
  type        = string
  description = "Name of the Cloud Armor security policy"
}

variable "health_check_name" {
  type        = string
  description = "Name of the health check"
}

variable "health_check_port" {
  type        = number
  description = "Port for the health check"
  default     = 3000
}

variable "backend_service_name" {
  type        = string
  description = "Name of the backend service"
}

variable "rate_limit_count" {
  type        = number
  description = "Max requests per minute before throttling"
  default     = 100
}