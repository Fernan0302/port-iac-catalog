output "id" {
  description = "ID interno del webhook"
  value       = port_webhook.this.id
}

output "identifier" {
  description = "Identifier del webhook"
  value       = port_webhook.this.identifier
}

output "url" {
  description = "URL generada para el webhook"
  value       = port_webhook.this.url
}

output "webhook_key" {
  description = "Clave del webhook"
  value       = port_webhook.this.webhook_key
  sensitive   = true
}