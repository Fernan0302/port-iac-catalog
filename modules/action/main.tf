##################################################
# Módulo: action
# Crea una Port Action (self-service, automation o
# ambas combinaciones), con su método de ejecución
# (webhook / upsert-entity) y permisos opcionales.
##################################################

resource "port_action" "this" {
  title       = var.title
  identifier  = var.identifier
  description = var.description
  icon        = var.icon
  publish     = var.publish

  automation_trigger = var.automation_trigger ? merge(
    var.any_run_change_event ? {
      any_run_change_event = {
        action_identifier = var.action_identifier
      }
    } : {},

    var.run_created_event ? {
      run_created_event = {
        action_identifier = var.action_identifier
      }
    } : {},

    var.run_updated_event ? {
      run_updated_event = {
        action_identifier = var.action_identifier
      }
    } : {},

    var.entity_created_event ? {
      entity_created_event = {
        blueprint_identifier = var.event_blueprint_identifier
      }
    } : {},

    var.entity_updated_event ? {
      entity_updated_event = {
        blueprint_identifier = var.event_blueprint_identifier
      }
    } : {},

    local.jq_condition_obj != null ? {
      jq_condition = local.jq_condition_obj
    } : {}
  ) : null

  self_service_trigger = var.self_service_trigger ? {
    operation             = var.operation
    blueprint_identifier   = var.blueprint_identifier
    user_properties = merge(
      length(var.list_string_properties) > 0 ? { string_props = var.list_string_properties } : {}
    )
    condition          = var.self_service_condition
    required_jq_query  = var.required_jq_query
    order_properties   = var.steps == null ? var.order_properties : null
    steps              = var.steps
    titles             = length(var.titles) > 0 ? var.titles : null
  } : null

  webhook_method = var.webhook_method ? {
    url          = var.url
    method       = var.method
    agent        = var.agent
    synchronized = var.synchronized
    headers      = var.headers
    body         = var.body_webhook_method
  } : null

  upsert_entity_method = var.upsert_entity_method ? {
    blueprint_identifier = var.upsert_entity_blueprint_identifier
    title                = var.upsert_entity_title
    mapping              = var.mapping_entity
  } : null

  approval_email_notification = var.email_notification ? {} : null
  required_approval           = var.required_approval
}

resource "port_action_permissions" "this" {
  count             = var.action_permissions != null ? 1 : 0
  action_identifier = port_action.this.identifier
  permissions       = local.action_permissions
}
