variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Region for the Artifact Registry"
}

variable "repository_id" {
  type        = string
  description = "Name of the Artifact Registry repository"
}