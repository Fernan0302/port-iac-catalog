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

variable "create_catalog_page" {
  type    = bool
  default = false
}

variable "force_delete_entities" {
  type    = bool
  default = false
}

##################################################
# Properties
##################################################

variable "list_string_properties" {
  description = "Mapa de propiedades tipo string. Clave = identifier de la propiedad."
  type = map(object({
    title       = string
    description = optional(string)
    required    = optional(bool, false)
    default     = optional(string)
    icon        = optional(string)
    format      = optional(string)
    enum        = optional(list(string))
    enum_colors = optional(map(string))
  }))
  default = {}
}

variable "list_number_properties" {
  description = "Mapa de propiedades tipo number."
  type = map(object({
    title       = string
    description = optional(string)
    required    = optional(bool, false)
    default     = optional(number)
    icon        = optional(string)
    minimum     = optional(number)
    maximum     = optional(number)
    enum        = optional(list(number))
    enum_colors = optional(map(string))
  }))
  default = {}
}

variable "list_boolean_properties" {
  description = "Mapa de propiedades tipo boolean."
  type = map(object({
    title       = string
    description = optional(string)
    required    = optional(bool, false)
    default     = optional(bool)
    icon        = optional(string)
  }))
  default = {}
}

variable "list_array_properties" {
  description = "Mapa de propiedades tipo array. Estructura libre (any) por la variedad de sub-tipos que admite Port."
  type    = any
  default = {}
}

variable "list_object_properties" {
  description = "Mapa de propiedades tipo object. Estructura libre (any)."
  type    = any
  default = {}
}

variable "list_mirror_properties" {
  description = "Mapa de mirror properties (propiedades espejadas desde relaciones)."
  type    = any
  default = {}
}

variable "list_calculation_properties" {
  description = "Mapa de calculation properties (propiedades calculadas vía JQ)."
  type    = any
  default = {}
}

variable "list_aggregation_properties" {
  description = "Mapa de aggregation properties (agregaciones sobre relaciones)."
  type    = any
  default = {}
}

##################################################
# Relations
##################################################

variable "has_relation" {
  type    = bool
  default = false
}

variable "list_relations" {
  description = <<-EOT
    Mapa de relaciones del blueprint. Ejemplo:
    {
      "environment" = {
        title    = "Environment"
        target   = "environment"
        required = true
        many     = false
      }
    }
  EOT
  type    = any
  default = {}
}

##################################################
# Ownership / Permissions
##################################################

variable "ownership" {
  description = "Configura el ownership del blueprint (team-based ownership)."
  type = object({
    type  = string
    title = optional(string)
    path  = optional(string)
  })
  default = null
}

variable "permissions" {
  description = <<-EOT
    Permisos del blueprint. Si readOwnedByTeam = true, el read queda
    restringido por team y se aplica vía PATCH directo a la API de Port
    (requiere la variable port_api_token en el ambiente que consume este
    módulo — ver README).
  EOT
  type = object({
    teams           = optional(list(string), [])
    readOwnedByTeam = optional(bool, false)
  })
  default = {
    teams           = []
    readOwnedByTeam = false
  }
}

variable "port_api_base_url" {
  type    = string
  default = "https://api.port.io"
}

variable "port_api_token" {
  description = "Bearer token de la API de Port. Solo requerido si permissions.readOwnedByTeam = true."
  type      = string
  default   = null
  sensitive = true
}
