resource "google_dns_managed_zone" "this" {
  dns_name   = local.zone_dns_name
  name       = local.zone_name
  visibility = local.visibility
  dynamic "private_visibility_config" {
    for_each = length(concat(var.gke_visibility, var.network_visibility)) > 0 ? [0] : []
    content {
      dynamic "gke_clusters" {
        for_each = var.gke_visibility
        content {
          gke_cluster_name = gke_clusters.value
        }
      }
      dynamic "networks" {
        for_each = var.network_visibility
        content {
          network_url = networks.value
        }
      }
    }
  }
  depends_on = [
    data.google_dns_managed_zone.parent
  ]
}

resource "google_dns_record_set" "NS_to_parent" {
  count        = var.parent_zone_name != null && local.visibility != "private" ? 1 : 0
  managed_zone = data.google_dns_managed_zone.parent.0.name
  name         = "${var.zone_name}.${data.google_dns_managed_zone.parent.0.dns_name}"
  type         = "NS"
  ttl          = 3600
  rrdatas      = google_dns_managed_zone.this.name_servers
}

resource "google_dns_record_set" "A" {
  for_each     = var.A_records
  managed_zone = google_dns_managed_zone.this.name
  name = (
    each.key == "@"
    ? google_dns_managed_zone.this.dns_name
    : "${each.key}.${google_dns_managed_zone.this.dns_name}"
  )
  type    = "A"
  ttl     = each.value.ttl
  rrdatas = each.value.values
}

resource "google_dns_record_set" "AAAA" {
  for_each     = var.AAAA_records
  managed_zone = google_dns_managed_zone.this.name
  name = (
    each.key == "@"
    ? google_dns_managed_zone.this.dns_name
    : "${each.key}.${google_dns_managed_zone.this.dns_name}"
  )
  type    = "AAAA"
  ttl     = each.value.ttl
  rrdatas = each.value.values
}
