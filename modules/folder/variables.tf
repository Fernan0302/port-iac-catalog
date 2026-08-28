variable "identifier" {
  description = "Identificador único del folder en Port"
  type        = string
}

variable "title" {
  description = "Nombre visible del folder"
  type        = string
  default     = null
}

variable "parent" {
  description = "Identificador del folder padre"
  type        = string
  default     = null
}

variable "after" {
  description = "Identificador del folder después del cual se ubicará este folder"
  type        = string
  default     = null
}