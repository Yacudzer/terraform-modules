locals {
  need_routed = var.nat != null || var.service_network != null
}

resource "google_compute_network" "this" {
  project                 = var.google_project
  name                    = var.name
  auto_create_subnetworks = false
  mtu                     = 1500
}

resource "google_compute_router" "this" {
  count   = local.need_routed ? 1 : 0
  region  = var.google_region
  project = var.google_project
  name    = "${var.name}-gw"
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  count                              = var.nat != null ? 1 : 0
  region                             = var.google_region
  project                            = var.google_project
  name                               = var.nat.name
  nat_ip_allocate_option             = var.nat.ip_allocate
  router                             = google_compute_router.this.0.name
  source_subnetwork_ip_ranges_to_nat = var.nat.source_subnetwork_ip_ranges_to_nat
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "services_network_private_ip_range" {
  count         = var.service_network != null ? 1 : 0
  project       = var.google_project
  name          = "services-private-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = split("/", var.service_network)[0]
  prefix_length = split("/", var.service_network)[1]
  network       = google_compute_network.this.id
}

resource "google_service_networking_connection" "service_network_connection" {
  count                   = var.service_network != null ? 1 : 0
  network                 = google_compute_network.this.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.services_network_private_ip_range.0.name
  ]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  count                = var.service_network != null ? 1 : 0
  project              = var.google_project
  peering              = google_service_networking_connection.service_network_connection.0.peering
  network              = google_compute_network.this.name
  import_custom_routes = true
  export_custom_routes = true
}
