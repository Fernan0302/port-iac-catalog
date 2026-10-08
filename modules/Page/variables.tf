variable "identifier" {
description = "Identificador único de la página"
type        = string
}

variable "type" {
description = "Tipo de página: blueprint-entities, dashboard, home o entity"
type        = string

validation {
condition = contains(
[
"blueprint-entities",
"dashboard",
"home",
"entity"
],
var.type
)

error_message = "El tipo debe ser: blueprint-entities, dashboard, home o entity."

}
}

variable "title" {
description = "Título de la página"
type        = string
default     = null
}

variable "description" {
description = "Descripción de la página"
type        = string
default     = null
}

variable "icon" {
description = "Icono de la página"
type        = string
default     = null
}

variable "locked" {
description = "Indica si la página está bloqueada para edición"
type        = bool
default     = false
}

variable "blueprint" {
description = "Identifier del Blueprint asociado. Aplica para páginas blueprint-entities y entity"
type        = string
default     = null
}

variable "parent" {
description = "Identifier de la carpeta padre donde se ubicará la página"
type        = string
default     = null
}

variable "after" {
description = "Identifier de la página o carpeta después de la cual se ubicará esta página"
type        = string
default     = null
}

variable "page_filters" {
description = "Lista de filtros de la página en formato JSON"
type        = list(string)
default     = []
}

variable "widgets" {
  description = "Lista de widgets de la página"
  type        = list(any)
  default     = []
}