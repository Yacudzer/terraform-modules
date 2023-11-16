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
      name        = string
      ip_allocate = optional(string,"AUTO_ONLY")
      source_subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS_ALL_IP_RANGES")
    }
  )
  nullable = true
  default  = null
}
