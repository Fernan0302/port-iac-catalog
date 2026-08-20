variable "identifier" {
  description = "Identificador único de la entidad"
  type        = string
}

variable "title" {
  description = "Título visible de la entidad"
  type        = string
}

variable "blueprint_identifier" {
  description = "Identificador del blueprint al que pertenece esta entidad"
  type        = string
}

variable "icon" {
  description = "Icono de la entidad (opcional, hereda el del blueprint si se omite)"
  type        = string
  default     = null
}

variable "run_id" {
  description = "ID de ejecución de Port (útil cuando la entidad se crea desde un self-service action)"
  type        = string
  default     = null
}

variable "string_props" {
  type    = any
  default = {}
}

variable "number_props" {
  type    = any
  default = {}
}

variable "boolean_props" {
  type    = any
  default = {}
}

variable "array_props" {
  type    = any
  default = {}
}

variable "object_props" {
  type    = any
  default = {}
}


variable "single_relations" {
  description = "Mapa relación=entidad_destino para relaciones many=false"
  type        = map(string)
  default     = {}
}

variable "many_relations" {
  description = "Mapa relación=[entidad_destino,...] para relaciones many=true"
  type        = map(list(string))
  default     = {}
}
