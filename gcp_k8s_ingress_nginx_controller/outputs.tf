output "ip" {
  description = "Ip address (external or internal) for applying DNS names"
  value       = google_compute_address.static_ip[local.last_element_from_current_state].address
}

output "current_state" {
  description = "Current state with some debug information. Works only when rotation is enabled."
  value       = local.current_state_full
}
