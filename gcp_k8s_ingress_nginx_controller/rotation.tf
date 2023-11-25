resource "random_pet" "rotated_resources" {
  for_each  = toset(local.current_state)
  length    = 2
  separator = "-"
}
