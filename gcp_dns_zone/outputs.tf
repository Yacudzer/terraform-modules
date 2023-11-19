output "zone_id" {
  value = google_dns_managed_zone.this.id
}

output "zone_name" {
  value = google_dns_managed_zone.this.name
}

output "zone_dns_name" {
  value = google_dns_managed_zone.this.dns_name
}

output "name_servers" {
  value = google_dns_managed_zone.this.name_servers
}
