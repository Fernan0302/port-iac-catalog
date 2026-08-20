##################################################
# Módulo: blueprint
# Crea un blueprint de Port con propiedades tipadas,
# relaciones, ownership, aggregation properties y
# permisos (incluyendo el caso "owned by team" que
# el provider no soporta nativamente — ver permissions.tf).
##################################################

resource "port_blueprint" "this" {
  title                 = var.title
  identifier            = var.identifier
  description           = var.description
  icon                  = var.icon
  create_catalog_page   = var.create_catalog_page
  force_delete_entities = var.force_delete_entities

  properties = {
    string_props = {
      for k, v in var.list_string_properties : k => merge(
        v,
        try(v.enum_colors, null) != null ? { enumColors = v.enum_colors } : {}
      )
    }
    number_props = {
      for k, v in var.list_number_properties : k => merge(
        v,
        try(v.enum_colors, null) != null ? { enumColors = v.enum_colors } : {}
      )
    }
    boolean_props = var.list_boolean_properties
    array_props   = var.list_array_properties
    object_props  = var.list_object_properties
  }

  relations               = var.has_relation ? var.list_relations : {}
  mirror_properties       = var.list_mirror_properties
  calculation_properties  = var.list_calculation_properties

  ownership = var.ownership
}

resource "port_aggregation_properties" "this" {
  count                = length(var.list_aggregation_properties) > 0 ? 1 : 0
  blueprint_identifier = port_blueprint.this.identifier
  properties           = var.list_aggregation_properties
}
