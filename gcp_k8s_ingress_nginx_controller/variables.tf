variable "name" {
  description = "Name of ingress controller"
  type        = string
}

variable "namespace" {
  description = "Namespace for creating nginx controller"
  type        = string
  default     = "ingress-nginx"
}

variable "google_region" {
  description = "Region for creating address"
  type        = string
}

variable "pod_labels" {
  description = "Variables for setting to pods and selector of load-balancer"
  type        = map(string)
  validation {
    condition     = length(var.pod_labels) > 0
    error_message = "Variable 'pod_labels' must not be empty"
  }
}

variable "address_type" {
  description = "EXTERNAL or INTERNAL address"
  type        = string
  validation {
    condition     = var.address_type == "EXTERNAL" || var.address_type == "INTERNAL"
    error_message = "'address_type' must be EXTERNAL or INTERNAL"
  }
  default = "EXTERNAL"
}

variable "subnetwork_id" {
  description = "Subnetwork for creating IP if address_type is INTERNAL"
  type        = string
  default     = null
}

variable "yaml_values" {
  description = "List of yaml-files for substitute values"
  type        = list(string)
  default     = []
}

variable "chart_version" {
  default     = "4.8.3"
  description = "Version of chart for using. Change it if you know what are you doing."
}

variable "tags" {
  description = "Google labels for this resources"
  type        = map(string)
  default     = {}
}

variable "rotation" {
  description = "Configuration for rotaion. rotation_minutes: how often need to change new ip; keep_minutes: how long need to store old ip;"
  type = object(
    {
      rotation_minutes                  = number
      keep_minutes                      = number
      state_bucket_name                 = string
      previous_state_http_response_code = number
      previous_state_http_response_body = string
    }
  )
  nullable = false
}
