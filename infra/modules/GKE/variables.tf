variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "region" {
  type        = string
  description = "Region for the GKE cluster"
}

variable "node_zones" {
  type        = list(string)
  description = "Zones for cluster nodes"
  default     = ["asia-southeast1-a", "asia-southeast1-b", "asia-southeast1-c"]
}

variable "network" {
  type        = string
  description = "VPC self link"
}

variable "subnetwork" {
  type        = string
  description = "Subnet self link"
}

variable "pods_range_name" {
  type        = string
  description = "Secondary range name for pods"
}

variable "services_range_name" {
  type        = string
  description = "Secondary range name for services"
}

variable "master_ipv4_cidr" {
  type        = string
  description = "CIDR for GKE master nodes"
  default     = "172.16.0.0/28"
}

variable "system_pool_name" {
  type        = string
  description = "Name of the system node pool"
  default     = "system-pool"
}

variable "services_pool_name" {
  type        = string
  description = "Name of the services node pool"
  default     = "services-pool"
}

variable "system_node_count" {
  type        = number
  description = "Node count for system pool"
  default     = 1
}

variable "system_machine_type" {
  type        = string
  description = "Machine type for system node pool"
  default     = "e2-medium"
}

variable "services_machine_type" {
  type        = string
  description = "Machine type for services node pool"
  default     = "e2-medium"
}

variable "services_min_nodes" {
  type        = number
  description = "Min nodes for services pool autoscaling"
  default     = 1
}

variable "services_max_nodes" {
  type        = number
  description = "Max nodes for services pool autoscaling"
  default     = 5
}

variable "autoscaling_cpu_min" {
  type        = number
  description = "Min CPU cores for cluster autoscaling"
  default     = 1
}

variable "autoscaling_cpu_max" {
  type        = number
  description = "Max CPU cores for cluster autoscaling"
  default     = 20
}

variable "autoscaling_mem_min" {
  type        = number
  description = "Min memory GB for cluster autoscaling"
  default     = 4
}

variable "autoscaling_mem_max" {
  type        = number
  description = "Max memory GB for cluster autoscaling"
  default     = 64
}