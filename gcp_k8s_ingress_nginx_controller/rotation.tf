resource "google_storage_bucket_object" "rotation_data" {
  bucket  = var.rotation.state_bucket_name
  name    = local.state_object_name
  content = jsonencode(local.current_state_full)
}

resource "random_pet" "rotated_resources" {
  for_each  = toset(local.current_state)
  length    = 2
  separator = "-"
}
