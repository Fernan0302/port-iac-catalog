output "id" {
description = "ID interno de la página"
value       = port_page.this.id
}

output "identifier" {
description = "Identifier de la página"
value       = port_page.this.identifier
}

output "title" {
description = "Título de la página"
value       = port_page.this.title
}

output "created_at" {
description = "Fecha de creación de la página"
value       = port_page.this.created_at
}

output "created_by" {
description = "Usuario que creó la página"
value       = port_page.this.created_by
}

output "updated_at" {
description = "Fecha de última actualización"
value       = port_page.this.updated_at
}

output "updated_by" {
description = "Usuario que realizó la última actualización"
value       = port_page.this.updated_by
}
