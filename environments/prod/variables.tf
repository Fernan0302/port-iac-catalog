variable "port_client_id" {
  type      = string
  sensitive = true
}

variable "port_client_secret" {
  type      = string
  sensitive = true
}

variable "port_base_url" {
  type    = string
  default = "https://api.us.getport.io"
}

variable "newrelic_ingest_webhook_signature" {
  type      = string
  sensitive = true
}