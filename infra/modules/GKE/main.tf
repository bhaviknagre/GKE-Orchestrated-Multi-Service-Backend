resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.region

  node_locations           = var.node_zones
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  network                  = var.network
  subnetwork               = var.subnetwork

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }

  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }

  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      minimum       = var.autoscaling_cpu_min
      maximum       = var.autoscaling_cpu_max
    }

    resource_limits {
      resource_type = "memory"
      minimum       = var.autoscaling_mem_min
      maximum       = var.autoscaling_mem_max
    }

    auto_provisioning_defaults {
      management {
        auto_repair  = true
        auto_upgrade = true
      }
      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  release_channel {
    channel = "REGULAR"
  }

  enable_shielded_nodes = true
}

resource "google_container_node_pool" "system_pool" {
  name       = var.system_pool_name
  project    = var.project_id
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.system_node_count

  depends_on = [google_container_cluster.primary]

  node_config {
    machine_type = var.system_machine_type

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = { role = "system" }

    taint {
      key    = "system"
      value  = "true"
      effect = "NO_SCHEDULE"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_container_node_pool" "services_pool" {
  name     = var.services_pool_name
  project  = var.project_id
  cluster  = google_container_cluster.primary.name
  location = var.region

  autoscaling {
    min_node_count = var.services_min_nodes
    max_node_count = var.services_max_nodes
  }

  node_config {
    machine_type = var.services_machine_type

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = { role = "services" }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}