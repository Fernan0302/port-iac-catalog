# Módulo: folder
# Crea una folder

resource "port_folder" "this" {
  identifier = var.identifier
  title      = var.title
  parent     = var.parent
  after      = var.after
}