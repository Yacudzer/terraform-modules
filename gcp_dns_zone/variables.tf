variable "zone_name" {
  description = "name of zone for creating"
  type        = string
}

variable "visibility" {
  description = "public or private"
  type        = string
  validation {
    condition     = try(contains(["public", "private"], var.visibility), true)
    error_message = "var 'visibility' must be 'public' or 'private'"
  }
  default = "private"
}

variable "network_visibility" {
  description = "List of networks id for connecting"
  type        = list(string)
  default     = []
}

variable "gke_visibility" {
  description = "List of GKE id for connecting"
  type        = list(string)
  default     = []
}

variable "parent_zone_name" {
  description = "id of parent zone if this is subdomain"
  type        = string
  default     = null
}
