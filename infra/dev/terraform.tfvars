# Networking

project_id    = "bhavik-nagre-1773724371"
vpc_name      = "microservice-vpc"
subnet_name   = "gke-subnet"
region        = "asia-southeast1"
subnet_cidr   = "10.0.0.0/16"
pods_cidr     = "10.10.0.0/16"
services_cidr = "10.20.0.0/20"
router_name   = "nat-router"
nat_name      = "cloud-nat"

# Artifact Registry
repository_id = "ollion-practise-project-repo"

# Secret Manager
db_password         = "Bhavik123" # ← override at runtime via TF_VAR_db_password
secret_id           = "db-password"
gke_sa_account_id   = "gke-workload-sa"
gke_sa_display_name = "GKE Workload Identity Service Account"


# Cloud Armor
policy_name          = "order-service-waf-policy"
health_check_name    = "order-service-health-check"
health_check_port    = 3000
backend_service_name = "order-service-backend"
rate_limit_count     = 100

# Cloud SQL
private_ip_name   = "sql-private-ip"
sql_instance_name = "capstone-postgres"
sql_instance_tier = "db-custom-2-7680"
database_names    = ["orderdb", "inventorydb"]
db_user           = "appuser"

# Observability

#WEBHOOK URL 
alert_email              = "bhaviknagre1432@gmail.com"
slack_webhook_url        = "CHANGE_ME" # export TF_VAR_slack_webhook_url=
obs_service_name         = "order-service"
obs_service_display_name = "Order Service"
metric_name              = "app_5xx_errors"

# GKE Cluster
cluster_name          = "capstone-cluster"
node_zones            = ["asia-southeast1-a", "asia-southeast1-b", "asia-southeast1-c"]
master_ipv4_cidr      = "172.16.0.0/28"
system_machine_type   = "e2-medium"
services_machine_type = "e2-medium"
services_min_nodes    = 1
services_max_nodes    = 5