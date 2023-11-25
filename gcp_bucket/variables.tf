variable "google_region" {
  description = "Region for allocating database"
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}

variable "versioning" {
  description = "Versioning for bucket"
  type        = bool
  default     = true
}

variable "lifecycle_rule" {
  type = object(
    {
      type = string
      age  = number
    }
  )
  default = {
    type = "Delete"
    age  = 7
  }
}

variable "public_access_prevention" {
  description = "Prevent public access for this bucket"
  type        = bool
  default     = true
}