resource "google_compute_subnetwork" "this" {
  project       = var.google_project
  region        = var.google_region
  name          = var.name
  ip_cidr_range = var.ip_cidr_range
  network       = var.network_id
}
