variable "port_client_id" {
  description = "Client ID de Port (inyectado por el pipeline vía secrets)"
  type        = string
  sensitive   = true
}

variable "port_client_secret" {
  description = "Client Secret de Port (inyectado por el pipeline vía secrets)"
  type        = string
  sensitive   = true
}

variable "port_base_url" {
  description = "URL base de la API de Port"
  type        = string
  default     = "https://api.getport.io"
}
