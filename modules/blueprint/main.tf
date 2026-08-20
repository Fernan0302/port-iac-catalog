# Módulo: blueprint
# Crea un blueprint de Port con propiedades,
# mirror properties y relaciones configurables.

resource "port_blueprint" "this" {
  identifier  = var.identifier
  title       = var.title
  icon        = var.icon
  description = var.description

  properties = {
    string_props  = var.string_props
    number_props  = var.number_props
    boolean_props = var.boolean_props
    array_props   = var.array_props
    object_props  = var.object_props
  }

  mirror_properties = var.mirror_properties
  relations         = var.relations
}
