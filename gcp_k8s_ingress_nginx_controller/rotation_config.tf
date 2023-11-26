locals {
  state_object_name = "${var.name}.json"

  start_of_times = "0000-01-01T00:00:00Z"
  current_date   = plantimestamp()

  previous_state = (
    var.rotation.previous_state_http_response_code == 200
    ? jsondecode(var.rotation.previous_state_http_response_body) : (
      var.rotation.previous_state_http_response_code == 404
      ? {}
      : raise("Something wrong with http ansewer (code is ${var.rotation.previous_state_http_response_code})")
    )
  )

  previous_state_pure  = [for key, value in local.previous_state : key]
  last_state_timestamp = try(element(local.previous_state_pure, length(local.previous_state_pure) - 1), local.start_of_times)
  need_to_rotate = timecmp(
    timeadd(local.current_date, "${var.rotation.rotation_minutes * -1}m"),
    local.last_state_timestamp
  ) == 1


  state_without_old = [for ts in local.previous_state_pure : ts
    if timecmp(ts, timeadd(local.current_date, "${var.rotation.keep_minutes * -1}m")) == 1
  ]

  current_state = (
    var.rotation.previous_state_http_response_code == 404
    ? [local.current_date]
    : (
      local.need_to_rotate
      ? concat(local.state_without_old, [local.current_date])
      : local.state_without_old
    )
  )
  #  current_state = [local.current_date]
  current_state_full = {
    for ts in local.current_state : ts =>
    {
      ip_address = google_compute_address.static_ip[ts].address
      ip_name    = google_compute_address.static_ip[ts].name
    }
  }

  last_element_from_current_state = element(local.current_state, length(local.current_state) - 1)
}
