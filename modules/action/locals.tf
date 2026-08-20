locals {
  default_roles = ["Admin"]

  execute_teams = try(var.action_permissions.execute.teams, [])
  approve_teams = try(var.action_permissions.approve.teams, [])
  approve_roles = try(var.action_permissions.approve.roles, [])

  approve_policy_json = (
    try(var.action_permissions.approve.policy, null) == null
    ? null
    : jsonencode(var.action_permissions.approve.policy)
  )

  action_permissions = {
    "execute" = {
      "ownedByTeam" = true
      "users"       = []
      "teams"       = local.execute_teams
      "roles"       = local.default_roles
    }
    "approve" = {
      "users"  = []
      "teams"  = local.approve_teams
      "roles"  = local.approve_roles
      "policy" = local.approve_policy_json
    }
  }

  jq_condition_obj = (
    var.jq_condition == null ? null :
    length(try(var.jq_condition.expressions, [])) > 0 ? {
      expressions = tolist(var.jq_condition.expressions)
      combinator  = tostring(try(var.jq_condition.combinator, "and"))
    } : null
  )
}
