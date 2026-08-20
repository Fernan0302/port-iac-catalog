output "this" {
  value = port_action.this
}

output "identifier" {
  value = port_action.this.identifier
}

output "permission" {
  value = try(port_action_permissions.this[0], null)
}
