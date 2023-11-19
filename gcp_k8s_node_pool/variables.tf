variable "google_region" {
  description = "Location for this node pool"
  type        = string
}

variable "cluster_id" {
  description = "Where need to attach this node pool"
  type        = string
}

variable "node_locations" {
  description = "Google zones for location nodes"
  type        = list(string)
}

variable "node_pool_name" {
  description = "Name of this nodepool"
  type        = string
}

variable "machine_type" {
  description = "Machine type for this nodes"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of HDD for these node"
  type        = number
  nullable    = false
}

variable "node_count" {
  description = "Node count or initial node count if autoscaring enable"
  type        = number
  default     = 1
  validation {
    condition     = var.node_count > 0
    error_message = "node count must be more than 1"
  }
  nullable = false
}

variable "autoscaling" {
  type = object(
    {
      location_policy      = optional(string, "BALANCED")
      total_min_node_count = number
      total_max_node_count = number
    }
  )
  default  = null
  nullable = true
}

variable "private_nodes" {
  description = "Use for enable_private_nodes param"
  type        = bool
  default     = true
}

variable "node_labels" {
  description = "Node labels for this pool"
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = "Taint for this nodes"
  type = list(object(
    {
      key    = string
      value  = string
      effect = string
    }
  ))
  default  = []
  nullable = false
}

variable "labels" {
  description = "Google labels for this resources"
  type        = map(string)
  default     = {}
}