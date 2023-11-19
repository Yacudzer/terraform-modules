variable "google_region" {
  description = "Region for allocating cluster"
  type        = string
}

variable "cluster_name" {
  description = "Prefix for cluster name"
  type        = string
  default     = "defaultname"
}

variable "cluster_network" {
  description = "VPC id for cluster creating"
  type        = string
}

variable "cluster_subnet" {
  description = "Subnet for cluster creating"
  type        = string
}

variable "cluster_version" {
  description = "Minimal version"
  type        = string
}

variable "node_prefix" {
  description = "Prefix for nodes, default = cluster name"
  type        = string
  default     = ""
}

variable "default_node_pool_config" {
  description = "Configuration for default node pool"
  type = object(
    {
      name                  = string
      node_count            = optional(number)
      number_zones_allocate = optional(number)
      machine_type          = string
      disk_size_gb          = number
    }
  )
  default = {
    name         = "default"
    machine_type = "e2-medium"
    disk_size_gb = 30
  }
}

variable "node_pools" {
  description = "List of all node pools"
  type = map(object(
    {
      pet                   = optional(bool, false)
      node_count            = optional(number, 1)
      number_zones_allocate = optional(number, 1)
      disk_size_gb          = optional(number, 30)
      machine_type          = optional(string, "e2-small")
      labels                = optional(map(string), {})
      taints = optional(list(object(
        {
          key    = string
          value  = string
          effect = string
        }
      )), [])
      autoscaling = optional(object(
        {
          total_min_node_count = number
          total_max_node_count = number
        }
      ), null)
    }
  ))
  default = {}
}

variable "labels" {
  description = "GCP labels"
  type        = map(string)
  default     = {}
}
