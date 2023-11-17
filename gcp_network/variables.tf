variable "google_project" {
  description = "Google project name"
  type        = string
}

variable "google_region" {
  description = "Google region for resources"
  type        = string
}

variable "name" {
  description = "Name of VPC"
  type        = string
}

variable "mtu" {
  description = "MTU for this network"
  type        = number
  default     = 1500
}

variable "nat" {
  type = object(
    {
      name                               = string
      ip_allocate                        = optional(string, "AUTO_ONLY")
      source_subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS_ALL_IP_RANGES")
    }
  )
  nullable = true
  default  = null
}

variable "service_network" {
  description = "Network for cloud services (SQL etc..."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = var.service_network == null || try(cidrsubnet(var.service_network, 0, 0),"") == var.service_network
    error_message = "Not valid network address. Must be correct CIDR or null"
  }
}
