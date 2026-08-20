# Módulo: entity
# Crea una entidad de Port sobre un blueprint dado.


resource "port_entity" "this" {
  identifier = var.identifier
  title      = var.title
  blueprint  = var.blueprint_identifier
  icon       = var.icon
  run_id     = var.run_id

  properties = {
    string_props  = var.string_props
    number_props  = var.number_props
    boolean_props = var.boolean_props
    array_props   = var.array_props
    object_props  = var.object_props
  }

  relations = {
    single_relations = var.single_relations
    many_relations    = var.many_relations
  }
}
