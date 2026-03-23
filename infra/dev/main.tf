module "networking" {
  source = "../modules/networking"

  project_id    = var.project_id
  vpc_name      = var.vpc_name
  subnet_name   = var.subnet_name
  region        = var.region
  subnet_cidr   = var.subnet_cidr
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr
  router_name   = var.router_name
  nat_name      = var.nat_name
}

module "api_enabling" {
  source     = "../modules/api_enabling"
  project_id = var.project_id
}

module "artifact_registry" {
  source        = "../modules/artifact_registry"
  project_id    = var.project_id
  region        = var.region
  repository_id = var.repository_id
}

module "secret_manager" {
  source              = "../modules/secrete_manager"
  project_id          = var.project_id
  location            = var.region
  secret_id           = var.secret_id
  db_password         = var.db_password
  gke_sa_account_id   = var.gke_sa_account_id
  gke_sa_display_name = var.gke_sa_display_name
}

module "cloudarmor" {
  source               = "../modules/cloud_armor"
  project_id           = var.project_id
  policy_name          = var.policy_name
  health_check_name    = var.health_check_name
  health_check_port    = var.health_check_port
  backend_service_name = var.backend_service_name
  rate_limit_count     = var.rate_limit_count
}

module "cloudsql" {
  source          = "../modules/cloudsql"
  project_id      = var.project_id
  region          = var.region
  network         = module.networking.vpc_self_link
  private_ip_name = var.private_ip_name
  instance_name   = var.sql_instance_name
  instance_tier   = var.sql_instance_tier
  database_names  = var.database_names
  db_user         = var.db_user
  db_password     = var.db_password
}

module "observability" {
  source                = "../modules/observability"
  project_id            = var.project_id
  alert_email           = var.alert_email
  slack_webhook_url     = var.slack_webhook_url
  service_name          = var.obs_service_name
  service_display_name  = var.obs_service_display_name
  metric_name           = var.metric_name
  cpu_threshold         = var.cpu_threshold
  memory_threshold      = var.memory_threshold
  pod_restart_threshold = var.pod_restart_threshold
  error_rate_threshold  = var.error_rate_threshold
  slo_burn_threshold    = var.slo_burn_threshold
  slo_goal              = var.slo_goal
}

module "gke" {
  source                = "../modules/GKE"
  project_id            = var.project_id
  cluster_name          = var.cluster_name
  region                = var.region
  node_zones            = var.node_zones
  network               = module.networking.vpc_self_link
  subnetwork            = module.networking.subnet_self_link
  pods_range_name       = module.networking.pods_range_name
  services_range_name   = module.networking.services_range_name
  master_ipv4_cidr      = var.master_ipv4_cidr
  system_machine_type   = var.system_machine_type
  services_machine_type = var.services_machine_type
  services_min_nodes    = var.services_min_nodes
  services_max_nodes    = var.services_max_nodes
}
