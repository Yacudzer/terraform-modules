resource "google_sql_database_instance" "this" {
  database_version = "POSTGRES_${var.sql_db_version}"
  region           = var.google_region
  name             = var.sql_db_name

  settings {
    tier                  = "db-custom-${var.num_cpu}-${var.memory_mb}"
    activation_policy     = "ALWAYS"
    disk_type             = "PD_SSD"
    disk_size             = var.db_disk_size_gb
    disk_autoresize       = var.disk_autoresize_limit_gb == -1 ? false : true
    disk_autoresize_limit = var.disk_autoresize_limit_gb != -1 ? var.disk_autoresize_limit_gb : null
    dynamic database_flags {
      for_each = var.enable_cloudsql_iam_auth ? [0] : []
      content {
        name  = "cloudsql.iam_authentication"
        value = "on"
      }
    }
    ip_configuration {
      private_network = var.network_id
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.key
          value = authorized_networks.value
        }
      }
      ipv4_enabled = false
    }
    user_labels = var.labels
  }
  deletion_protection = false
}

resource "google_dns_record_set" "this" {
  count        = var.dns_zone_name != null ? 1 : 0
  managed_zone = var.dns_zone_name
  name         = "${google_sql_database_instance.this.name}.${local.zone_dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas = [
    (
      local.visibility == "private"
      ? google_sql_database_instance.this.private_ip_address
      : google_sql_database_instance.this.public_ip_address
    )
  ]
  depends_on = [
    data.google_dns_managed_zone.dns_zone
  ]
}
