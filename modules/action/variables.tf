variable "identifier" {
  type = string
}

variable "title" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "icon" {
  type    = string
  default = "DefaultProperty"
}

variable "publish" {
  type    = bool
  default = false
}

# Trigger: automation

variable "automation_trigger" {
  type    = bool
  default = false
}

variable "action_identifier" {
  description = "Identifier de la acción que dispara este automation (para any_run_change_event / run_created_event / run_updated_event)."
  type    = string
  default = null
}

variable "any_run_change_event" {
  type    = bool
  default = false
}

variable "run_created_event" {
  type    = bool
  default = false
}

variable "run_updated_event" {
  type    = bool
  default = false
}

variable "entity_created_event" {
  type    = bool
  default = false
}

variable "entity_updated_event" {
  type    = bool
  default = false
}

variable "event_blueprint_identifier" {
  description = "Blueprint que dispara entity_created_event / entity_updated_event."
  type    = string
  default = null
}

variable "jq_condition" {
  description = "Condición JQ adicional para el automation trigger."
  type = object({
    expressions = list(string)
    combinator  = optional(string, "and")
  })
  default = {
    expressions = []
    combinator  = "and"
  }
}


# Trigger: self-service


variable "self_service_trigger" {
  type    = bool
  default = false
}

variable "operation" {
  description = "CREATE | DAY-2 | DELETE"
  type    = string
  default = null
}

variable "blueprint_identifier" {
  description = "Blueprint sobre el que actúa este self-service action."
  type    = string
  default = null
}

variable "list_string_properties" {
  description = "Mapa de propiedades string que se piden al usuario en el formulario (user_properties.string_props)."
  type    = any
  default = {}
}

variable "self_service_condition" {
  type    = string
  default = null
}

variable "required_jq_query" {
  type    = string
  default = null
}

variable "order_properties" {
  description = "Orden de las propiedades en el formulario. Mutuamente excluyente con steps."
  type    = list(string)
  default = null
}

variable "steps" {
  description = "Pasos del wizard (mutuamente excluyente con order_properties)."
  type = list(object({
    title       = string
    description = optional(string)
    order       = list(string)
  }))
  default = null
}

variable "titles" {
  description = "Bloques de título/descripción para los steps del wizard."
  type = map(object({
    title       = string
    description = string
  }))
  default = {}
}


# Backend method: webhook


variable "webhook_method" {
  type    = bool
  default = false
}

variable "url" {
  type    = string
  default = null
}

variable "method" {
  type    = string
  default = "POST"
}

variable "agent" {
  type    = bool
  default = false
}

variable "synchronized" {
  type    = bool
  default = false
}

variable "headers" {
  type    = map(any)
  default = null
}

variable "body_webhook_method" {
  type    = string
  default = null
}


# Backend method: upsert entity


variable "upsert_entity_method" {
  type    = bool
  default = false
}

variable "upsert_entity_blueprint_identifier" {
  type    = string
  default = null
}

variable "upsert_entity_title" {
  type    = string
  default = null
}

variable "mapping_entity" {
  type    = any
  default = {}
}


# Aprobación / notificaciones


variable "email_notification" {
  type    = bool
  default = false
}

variable "required_approval" {
  type    = bool
  default = false
}


# Permisos


variable "action_permissions" {
  description = "Permisos de execute/approve. null = no gestionar permisos desde Terraform."
  type = object({
    execute = optional(object({
      teams = optional(list(string))
    }))
    approve = optional(object({
      roles = optional(list(string))
      teams = optional(list(string))
      policy = optional(object({
        queries = map(object({
          rules = list(object({
            value    = string
            operator = string
            property = string
          }))
          combinator = string
        }))
        conditions = list(string)
      }))
    }))
  })
  default = null
}
