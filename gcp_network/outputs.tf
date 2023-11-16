output "network_id" {
  value = google_compute_network.this.id
}

output "network_name" {
  value = google_compute_network.this.name
}

output "network_mtu" {
  value = google_compute_network.this.mtu
}
