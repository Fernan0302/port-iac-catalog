variable "identifier" {
description = "Identificador único del webhook"
type        = string
default     = null
}

variable "title" {
description = "Título del webhook"
type        = string
default     = null
}

variable "description" {
description = "Descripción del webhook"
type        = string
default     = null
}

variable "icon" {
description = "Icono del webhook"
type        = string
default     = null
}

variable "enabled" {
description = "Indica si el webhook está habilitado"
type        = bool
default     = true
}

variable "mappings" {
description = "Configuración de los mappings del webhook"

type = list(object({
blueprint      = string
filter         = optional(string)
items_to_parse = optional(string)


operation = optional(object({
  type              = string
  delete_dependents = optional(bool)
}))

entity = object({
  identifier = string
  title      = optional(string)
  icon       = optional(string)
  team       = optional(string)
  properties = optional(map(string))
  relations  = optional(map(string))
})

}))

default = []
}

variable "security" {
description = "Configuración de seguridad del webhook"

type = object({
request_identifier_path = optional(string)
secret                  = optional(string)
signature_algorithm     = optional(string)
signature_header_name   = optional(string)
signature_prefix        = optional(string)
})

default   = null
sensitive = true
}
