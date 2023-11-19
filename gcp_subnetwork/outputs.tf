output "network_id" {
  value = google_compute_subnetwork.this.id
}

output "network_name" {
  value = google_compute_subnetwork.this.name
}

output "ip_cidr_range" {
  value = google_compute_subnetwork.this.ip_cidr_range
}
