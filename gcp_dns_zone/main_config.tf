data "google_dns_managed_zone" "parent" {
  count = var.parent_zone_name != null ? 1 : 0
  name  = var.parent_zone_name
}

locals {
  parent_dns_name   = try(data.google_dns_managed_zone.parent[0].dns_name, "")
  parent_name       = try(data.google_dns_managed_zone.parent[0].name, "")
  parent_visibility = try(data.google_dns_managed_zone.parent[0].visibility, "")

  zone_dns_name_without_parent = (
    substr(var.zone_name, length(var.zone_name) - 1, 1) == "."
    ? var.zone_name
    : "${var.zone_name}."
  )
  zone_dns_name = (
    var.parent_zone_name != null
    ? "${local.zone_dns_name_without_parent}${local.parent_dns_name}"
    : local.zone_dns_name_without_parent
  )
  zone_pre_name = (
    substr(var.zone_name, length(var.zone_name) - 1, 1) == "."
    ? substr(var.zone_name, 0, length(var.zone_name) - 1)
    : var.zone_name
  )
  zone_name_with_parent = (
    var.parent_zone_name != null
    ? "${local.zone_pre_name}-${local.parent_name}"
    : local.zone_pre_name
  )
  zone_name = replace(local.zone_name_with_parent, ".", "-")

  visibility = (
    var.parent_zone_name == null
    ? var.visibility
    : local.parent_visibility
  )
}
