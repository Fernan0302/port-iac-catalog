variable "port_client_id" {
  description = "Client ID de Port"
  type        = string
  sensitive   = true
}

variable "port_client_secret" {
  description = "Client Secret de Port"
  type        = string
  sensitive   = true
}

variable "port_base_url" {
  description = "URL base de la API de Port"
  type        = string
  default     = "https://api.getport.io"
}

variable "newrelic_ingest_webhook_signature" {
  description = "Firma utilizada por el webhook de New Relic"
  type        = string
  sensitive   = true
}