locals {
  default_node_allocate_zones = (
    var.default_node_pool_config.number_zones_allocate == null
    ? 2
    : var.default_node_pool_config.number_zones_allocate
  )
}

data "google_compute_zones" "compute_zones" {
  region = var.google_region
}
