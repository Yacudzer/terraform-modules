output "cluster_name" {
  value = google_container_cluster.this.name
}

output "cluster_id" {
  value = google_container_cluster.this.id
}

output "cluster_location" {
  description = "Where is this cluster located"
  value       = google_container_cluster.this.location
}

output "cluster_ipv4_cidr" {
  value = google_container_cluster.this.cluster_ipv4_cidr
}

output "cluster_ca_certificate" {
  value = google_container_cluster.this.master_auth.0.cluster_ca_certificate
}

output "cluster_endpoint" {
  value = google_container_cluster.this.endpoint
}

output "enable_autopilot" {
  value = google_container_cluster.this.enable_autopilot
}
