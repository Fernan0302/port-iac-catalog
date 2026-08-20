variable "identifier" {
  description = "Identificador único del blueprint"
  type        = string
}

variable "title" {
  description = "Título visible del blueprint"
  type        = string
}

variable "icon" {
  description = "Icono del blueprint (ver catálogo de iconos de Port)"
  type        = string
  default     = "Blueprint"
}

variable "description" {
  description = "Descripción del blueprint"
  type        = string
  default     = ""
}

variable "string_props" {
  description = "Mapa de propiedades tipo string"
  type        = any
  default     = {}
}

variable "number_props" {
  description = "Mapa de propiedades tipo number"
  type        = any
  default     = {}
}

variable "boolean_props" {
  description = "Mapa de propiedades tipo boolean"
  type        = any
  default     = {}
}

variable "array_props" {
  description = "Mapa de propiedades tipo array"
  type        = any
  default     = {}
}

variable "object_props" {
  description = "Mapa de propiedades tipo object"
  type        = any
  default     = {}
}

variable "mirror_properties" {
  description = "Mapa de mirror properties (propiedades espejadas desde relaciones)"
  type        = any
  default     = {}
}

variable "relations" {
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
