variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Region for Cloud SQL"
}

variable "network" {
  type        = string
  description = "VPC self link for private SQL"
}

variable "private_ip_name" {
  type        = string
  description = "Name of the private IP range"
}

variable "instance_name" {
  type        = string
  description = "Name of the Cloud SQL instance"
}

variable "instance_tier" {
  type        = string
  description = "Machine tier for Cloud SQL"
  default     = "db-custom-2-7680"
}

variable "database_names" {
  type        = list(string)
  description = "List of databases to create"
}

variable "db_user" {
  type        = string
  description = "Database user name"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}