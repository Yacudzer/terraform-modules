output "http_response_body" {
  value = data.http.this.response_body
}

output "http_response_code" {
  value = data.http.this.status_code
}
