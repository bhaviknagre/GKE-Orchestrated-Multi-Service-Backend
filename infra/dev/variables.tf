variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "pods_cidr" {
  type = string
}

variable "services_cidr" {
  type = string
}

variable "router_name" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "repository_id" {
  type = string
}

variable "secret_id" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "gke_sa_account_id" {
  type = string
}

variable "gke_sa_display_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "health_check_name" {
  type = string
}

variable "health_check_port" {
  type    = number
  default = 3000
}

variable "backend_service_name" {
  type = string
}

variable "rate_limit_count" {
  type    = number
  default = 100
}


variable "private_ip_name" {
  type = string
}

variable "sql_instance_name" {
  type = string
}

variable "sql_instance_tier" {
  type    = string
  default = "db-custom-2-7680"
}

variable "database_names" {
  type = list(string)
}

variable "db_user" {
  type = string
}

variable "alert_email" {
  type = string
}

variable "slack_webhook_url" {
  type      = string
  sensitive = true
}

variable "obs_service_name" {
  type = string
}

variable "obs_service_display_name" {
  type = string
}

variable "metric_name" {
  type    = string
  default = "app_5xx_errors"
}

variable "cpu_threshold" {
  type    = number
  default = 0.8
}

variable "memory_threshold" {
  type    = number
  default = 524288000
}

variable "pod_restart_threshold" {
  type    = number
  default = 3
}

variable "error_rate_threshold" {
  type    = number
  default = 2
}

variable "slo_burn_threshold" {
  type    = number
  default = 10
}

variable "slo_goal" {
  type    = number
  default = 0.995
}


variable "cluster_name" {
  type = string
}

variable "node_zones" {
  type = list(string)
}

variable "master_ipv4_cidr" {
  type    = string
  default = "172.16.0.0/28"
}

variable "system_machine_type" {
  type    = string
  default = "e2-medium"
}

variable "services_machine_type" {
  type    = string
  default = "e2-medium"
}

variable "services_min_nodes" {
  type    = number
  default = 1
}

variable "services_max_nodes" {
  type    = number
  default = 5
}