locals {
  need_routed = var.nat != null
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