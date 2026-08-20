output "identifier" {
  description = "Identificador del blueprint creado"
  value       = port_blueprint.this.identifier
}

output "id" {
  description = "ID interno del recurso en el state de Terraform"
  value       = port_blueprint.this.id
}
