resource "google_storage_bucket" "this" {
  location      = var.google_region
  name          = var.bucket_name
  force_destroy = true
  versioning {
    enabled = var.versioning
  }
  dynamic "lifecycle_rule" {
    for_each = var.versioning ? [0] : []
    content {
      action {
        type = var.lifecycle_rule.type
      }
      condition {
        days_since_noncurrent_time = var.lifecycle_rule.age
      }
    }
  }
  public_access_prevention = var.public_access_prevention ? "enforced" : null

}
