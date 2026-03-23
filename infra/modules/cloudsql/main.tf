resource "google_compute_global_address" "private_ip_range" {
  name          = var.private_ip_name
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  project          = var.project_id
  database_version = "POSTGRES_14"
  region           = var.region

  deletion_protection = true

  settings {
    tier = var.instance_tier

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }

    maintenance_window {
      day  = 7
      hour = 3
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "databases" {
  for_each = toset(var.database_names)
  name     = each.value
  project  = var.project_id
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "app_user" {
  name     = var.db_user
  project  = var.project_id
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}