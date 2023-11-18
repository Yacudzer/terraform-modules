variable "google_region" {
  description = "Region for allocating database"
  type        = string
}

variable "sql_db_version" {
  type = string
}

variable "sql_db_name" {
  type        = string
  description = "Name of database"
}

variable "num_cpu" {
  type        = number
  description = "Number of cpu for instance"
  validation {
    condition     = var.num_cpu == 1 || (var.num_cpu > 1 && var.num_cpu % 2 == 0)
    error_message = "num_cpu must be either 1 or an even number between 2 and 96"
  }
}

variable "memory_mb" {
  type        = number
  description = "Memory for instance, mb"
  validation {
    condition     = var.memory_mb % 256 == 0 && var.memory_mb >= 3840
    error_message = "Memory must be: a multiple of 256 MB and at least 3.75 GB (3840 MB)"
  }
}

variable "db_disk_size_gb" {
  type        = number
  description = "Size of disk for db, GB"
  validation {
    condition     = var.db_disk_size_gb > 1
    error_message = "db_disk_size_gb must be greater than 1 Gb"
  }
}

variable "disk_autoresize_limit_gb" {
  description = "-1: disable autoresize, other - enabled"
  type        = number
  validation {
    condition     = var.disk_autoresize_limit_gb >= -1
    error_message = "disk_autoresize_limit_gb must be greater or equal db_disk_size_gb OR 0 (unlimited), -1 (disabled)"
  }
  default = -1
}

variable "network_id" {
  type        = string
  description = "Network for DB"
}

variable "labels" {
  description = "GKE labels"
  type        = map(string)
  default     = {}
}

variable "authorized_networks" {
  description = "Networks which allow to connect"
  type        = map(string)
  default     = {}
}

variable "dns_zone_name" {
  description = "add dns-name for this zone"
  type        = string
  default     = null
}

variable "enable_cloudsql_iam_auth" {
  description = "Enable auth using service account"
  type        = bool
  default     = true
}