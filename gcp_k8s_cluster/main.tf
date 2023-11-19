resource "random_shuffle" "default_pool_zones" {
  input = data.google_compute_zones.compute_zones.names
  result_count = (
    local.default_node_allocate_zones > length(data.google_compute_zones.compute_zones.names) ?
    length(data.google_compute_zones.compute_zones.names) :
    local.default_node_allocate_zones
  )
}

resource "random_shuffle" "pool_zones_allocate" {
  for_each     = var.node_pools
  input        = data.google_compute_zones.compute_zones.names
  result_count = each.value.number_zones_allocate
}

resource "random_pet" "pool_name" {
  for_each  = { for pool_name, pool in var.node_pools : pool_name => null if pool.pet }
  length    = 2
  separator = "-"
}

resource "google_container_cluster" "this" {
  name     = var.cluster_name
  location = var.google_region
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  initial_node_count       = 1
  remove_default_node_pool = true
  node_locations           = [data.google_compute_zones.compute_zones.names[0]]
  enable_kubernetes_alpha  = false
  network                  = var.cluster_network
  subnetwork               = var.cluster_subnet
  min_master_version       = var.cluster_version
  deletion_protection      = false
  monitoring_config {
    managed_prometheus {
      enabled = false
    }
    enable_components = []
  }
  resource_labels = var.labels
}

module "default_node_pool" {
  source         = "../gcp_k8s_node_pool"
  google_region  = var.google_region
  cluster_id     = google_container_cluster.this.id
  node_locations = random_shuffle.default_pool_zones.result
  node_pool_name = var.default_node_pool_config.name
  machine_type   = var.default_node_pool_config.machine_type
  disk_size_gb   = var.default_node_pool_config.disk_size_gb
  node_count     = var.default_node_pool_config.node_count
  labels         = var.labels
  depends_on = [
    google_container_cluster.this,
    random_shuffle.default_pool_zones
  ]
}

module "node_pools" {
  for_each       = var.node_pools
  source         = "../gcp_k8s_node_pool"
  google_region  = var.google_region
  cluster_id     = google_container_cluster.this.id
  node_locations = random_shuffle.pool_zones_allocate[each.key].result
  node_pool_name = each.value.pet ? random_pet.pool_name[each.key].id : each.key
  node_count     = each.value.node_count
  machine_type   = each.value.machine_type
  disk_size_gb   = each.value.disk_size_gb
  node_labels    = each.value.labels
  node_taints    = each.value.taints
  autoscaling    = each.value.autoscaling
  labels         = var.labels
  depends_on = [
    google_container_cluster.this
  ]
}

