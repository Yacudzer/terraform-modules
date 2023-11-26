data "google_storage_object_signed_url" "this" {
  bucket   = var.bucket_name
  path     = var.object_name
  duration = "30s"
}

data "http" "this" {
  url   = data.google_storage_object_signed_url.this.signed_url
}
