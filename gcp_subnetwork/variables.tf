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
}

variable "network_id" {
  type = string
}
