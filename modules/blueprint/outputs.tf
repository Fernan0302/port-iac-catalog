output "this" {
  value = port_blueprint.this
}

output "identifier" {
  value = port_blueprint.this.identifier
}

output "id" {
  value = port_blueprint.this.id
}

output "permission" {
  value = try(port_blueprint_permissions.this[0], null)
}

output "aggregation_properties_ready" {
  value = try(port_aggregation_properties.this[0].id, null)
}
