resource "google_container_cluster" "default" {
  name     = var.cluster_name
  project  = var.project_id
  location = "us-central1"

  enable_autopilot         = false
  enable_l4_ilb_subsetting = true

  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id

  ip_allocation_policy {
    stack_type                    = "IPV4"
    services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.default.secondary_ip_range[1].range_name
  }

  deletion_protection = false
  initial_node_count = 1 
}

resource "google_container_node_pool" "default" {
  name       = "spark-gke-node-pool"
  project    = var.project_id
  location   = google_container_cluster.default.location
  cluster    = google_container_cluster.default.name

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    machine_type = "e2-medium"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 32
  }
}

