output "endpoint_ip" {
  value = google_sql_database_instance.this.ip_address
}

output "db_id" {
  value = google_sql_database_instance.this.id
}

output "dns_name" {
  value = (
    var.dns_zone_name != null
    ? google_dns_record_set.this[0].name
    : null
  )
}
