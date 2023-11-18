data "google_dns_managed_zone" "dns_zone" {
  count = var.dns_zone_name !=null ? 1 : 0
  name = var.dns_zone_name
}

locals {
  zone_dns_name = try(data.google_dns_managed_zone.dns_zone[0].dns_name,"")
  visibility = try(data.google_dns_managed_zone.dns_zone[0].visibility,"")
}
