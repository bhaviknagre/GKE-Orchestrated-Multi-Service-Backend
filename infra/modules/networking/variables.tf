variable "project_id" {
  type = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "region" {
  description = "Region where the subnet and router will be created"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pods_cidr" {
  description = "CIDR range for Kubernetes pods"
  type        = string
  default     = "10.10.0.0/16"
}

variable "services_cidr" {
  description = "CIDR range for Kubernetes services"
  type        = string
  default     = "10.20.0.0/20"
}

variable "router_name" {
  description = "Name of the Cloud Router"
  type        = string
  default     = "nat-router"
}

variable "nat_name" {
  description = "Name of the Cloud NAT"
  type        = string
  default     = "cloud-nat"
}