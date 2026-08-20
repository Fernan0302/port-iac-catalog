locals {
  teams        = coalesce(try(var.permissions.teams, []), [])
  default_role = "${var.identifier}-moderator"
  default_roles = [
    "Admin",
    local.default_role
  ]

  # Todas las claves de propiedades/relaciones definidas (útil para pages u orden de columnas)
  blueprint_property_keys = sort(distinct(flatten([
    try(keys(var.list_relations), []),
    try(keys(var.list_string_properties), []),
    try(keys(var.list_array_properties), []),
    try(keys(var.list_number_properties), []),
    try(keys(var.list_object_properties), []),
    try(keys(var.list_boolean_properties), [])
  ])))

  update_properties_to_configure = concat(
    try(keys(var.list_string_properties), []),
    try(keys(var.list_array_properties), []),
    try(keys(var.list_number_properties), []),
    try(keys(var.list_boolean_properties), [])
  )

  update_properties = length(local.update_properties_to_configure) > 0 ? {
    for v in local.update_properties_to_configure : v => {
      roles         = local.default_roles
      users         = []
      teams         = local.teams
      owned_by_team = false
    }
  } : null

  update_relations_to_configure = try(keys(var.list_relations), [])

  update_relations = length(local.update_relations_to_configure) > 0 ? {
    for v in local.update_relations_to_configure : v => {
      roles         = local.default_roles
      users         = []
      teams         = local.teams
      owned_by_team = false
    }
  } : null

  # Permisos en formato "nativo" del provider (snake_case) — usados por
  # port_blueprint_permissions cuando NO se necesita el workaround de PATCH.
  permissions_blueprint_native = {
    read = {
      roles         = local.default_roles
      users         = []
      teams         = local.teams
      owned_by_team = var.permissions.readOwnedByTeam
    }
    register = {
      roles         = local.default_roles
      users         = []
      teams         = local.teams
      owned_by_team = false
    }
    update = {
      roles         = local.default_roles
      users         = []
      teams         = local.teams
      owned_by_team = false
    }
    unregister = {
      roles         = local.default_roles
      users         = []
      teams         = local.teams
      owned_by_team = false
    }
    update_properties = local.update_properties
    update_metadata_properties = {
      "icon"       = { roles = ["Admin"], users = [], teams = local.teams }
      "identifier" = { roles = ["Admin"], users = [], teams = local.teams }
      "team"       = { roles = ["Admin"], users = [], teams = local.teams }
      "title"      = { roles = ["Admin"], users = [], teams = local.teams }
    }
    update_relations = local.update_relations
  }

  # ----------------------------------------------------------------
  # Permisos en formato "API" (camelCase) — solo se usan cuando
  # readOwnedByTeam = true, porque el provider no soporta ese caso y
  # hay que aplicarlo vía PATCH directo a la API (ver permissions.tf).
  # ----------------------------------------------------------------
  api_read = {
    users       = try(local.permissions_blueprint_native.read.users, [])
    teams       = try(local.permissions_blueprint_native.read.teams, [])
    roles       = try(local.permissions_blueprint_native.read.roles, [])
    ownedByTeam = try(local.permissions_blueprint_native.read.owned_by_team, false)
  }

  api_register = {
    users       = try(local.permissions_blueprint_native.register.users, [])
    teams       = try(local.permissions_blueprint_native.register.teams, [])
    roles       = try(local.permissions_blueprint_native.register.roles, [])
    ownedByTeam = try(local.permissions_blueprint_native.register.owned_by_team, false)
  }

  api_update = {
    users       = try(local.permissions_blueprint_native.update.users, [])
    teams       = try(local.permissions_blueprint_native.update.teams, [])
    roles       = try(local.permissions_blueprint_native.update.roles, [])
    ownedByTeam = try(local.permissions_blueprint_native.update.owned_by_team, false)
  }

  api_unregister = {
    users       = try(local.permissions_blueprint_native.unregister.users, [])
    teams       = try(local.permissions_blueprint_native.unregister.teams, [])
    roles       = try(local.permissions_blueprint_native.unregister.roles, [])
    ownedByTeam = try(local.permissions_blueprint_native.unregister.owned_by_team, false)
  }

  api_update_properties = local.update_properties != null ? {
    for prop, rule in local.update_properties : prop => {
      users       = try(rule.users, [])
      teams       = try(rule.teams, [])
      roles       = try(rule.roles, [])
      ownedByTeam = try(rule.owned_by_team, false)
    }
  } : null

  api_update_relations = local.update_relations != null ? {
    for rel, rule in local.update_relations : rel => {
      users       = try(rule.users, [])
      teams       = try(rule.teams, [])
      roles       = try(rule.roles, [])
      ownedByTeam = try(rule.owned_by_team, false)
    }
  } : null

  permissions_entities_api = merge(
    {
      read       = local.api_read
      register   = local.api_register
      update     = local.api_update
      unregister = local.api_unregister
    },
    local.api_update_properties != null ? { updateProperties = local.api_update_properties } : {},
    local.api_update_relations != null ? { updateRelations = local.api_update_relations } : {}
  )

  port_permissions_payload_api = jsonencode({
    entities = local.permissions_entities_api
  })
}
