variable "identifier" {
  type = string
}

variable "title" {
  type = string
}

variable "blueprint_identifier" {
  description = "Identificador del blueprint sobre el que aplica el scorecard"
  type        = string
}

variable "rules" {
  description = <<-EOT
    Lista de reglas del scorecard. Ejemplo:
    [
      {
        identifier = "has_readme"
        title      = "Tiene README"
        level      = "Bronze"
        query = {
          combinator = "and"
          conditions = [
            "{\"property\":\"readme_url\",\"operator\":\"isNotEmpty\"}"
          ]
        }
      }
    ]
  EOT
  type    = any
  default = []
}
