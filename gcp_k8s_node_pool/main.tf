resource "google_container_node_pool" "this" {
  cluster            = var.cluster_id
  name               = var.node_pool_name
  location           = var.google_region
  node_locations     = var.node_locations
  initial_node_count = local.autoscaling_enabled ? var.node_count : null
  node_count         = local.autoscaling_enabled ? null : var.node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    labels       = var.node_labels

    dynamic "taint" {
      for_each = var.node_taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }
    resource_labels = var.labels
  }

  network_config {
    enable_private_nodes = var.private_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  dynamic "autoscaling" {
    for_each = local.autoscaling_enabled ? [0] : []
    content {
      location_policy      = var.autoscaling.location_policy
      total_min_node_count = var.autoscaling.total_min_node_count
      total_max_node_count = var.autoscaling.total_max_node_count
    }
  }

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
}
