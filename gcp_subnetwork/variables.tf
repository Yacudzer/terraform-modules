variable "google_project" {
  description = "Google project name"
  type        = string
}

variable "google_region" {
  description = "Google region for resources"
  type        = string
}

variable "name" {
  type = string
}

variable "ip_cidr_range" {
  type = string
  validation {
    condition     = cidrsubnet(var.ip_cidr_range, 0, 0) == var.ip_cidr_range
    error_message = "Not valid network address"
  }
}

variable "network_id" {
  type = string
}
