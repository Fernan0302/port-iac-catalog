# Módulo: scorecard
# Crea un scorecard (métricas de madurez/gobierno)
# asociado a un blueprint.

resource "port_scorecard" "this" {
  identifier           = var.identifier
  title                = var.title
  blueprint_identifier = var.blueprint_identifier

  rules = var.rules
}
