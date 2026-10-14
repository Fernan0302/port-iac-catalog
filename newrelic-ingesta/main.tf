module "new_relic_alert_webhook_blueprint" {
  source = "../modules/blueprint"

  identifier  = "new-relic-alert-webhook"
  title       = "Alerta New Relic Webhook"
  description = "Este blueprint representa una alerta de New Relic recibida vía webhook"
  icon        = "NewRelic"

  list_string_properties = {
    prioridad = {
      title       = "Prioridad"
      description = "Prioridad de la alerta en New Relic"
      required    = false
      default     = null
      icon        = null
      format      = null
      enum        = ["CRITICAL", "HIGH", "MEDIUM", "LOW"]
      enum_colors = {
        CRITICAL = "red"
        HIGH     = "red"
        MEDIUM   = "yellow"
        LOW      = "green"
      }
    }

    estado = {
      title       = "Estado"
      description = "Estado actual de la alerta en New Relic"
      required    = false
      default     = null
      icon        = null
      format      = null
      enum        = ["ACTIVATED", "CLOSED", "CREATED"]
      enum_colors = {
        ACTIVATED = "yellow"
        CLOSED    = "green"
        CREATED   = "lightGray"
      }
    }

    "codigo-problema" = {
      title       = "ID de Issue"
      description = "Identificador de la issue en New Relic (body.id)"
      required    = false
      default     = null
      icon        = null
      format      = null
    }

    "url-problema" = {
      title       = "URL de la Issue"
      description = "Enlace a la issue en la consola de New Relic"
      required    = false
      default     = null
      icon        = null
      format      = "url"
    }

    "titulo-nr" = {
      title       = "Título"
      description = "Título de la issue en New Relic"
      required    = false
      default     = null
      icon        = null
      format      = null
    }

    disparador = {
      title       = "Disparador"
      description = "Evento que disparó el webhook (por ejemplo, INCIDENT_CLOSED)"
      required    = false
      default     = null
      icon        = null
      format      = null
    }

    "fecha-creacion" = {
      title       = "Creado en"
      description = "Fecha y hora de creación de la issue en New Relic"
      required    = false
      default     = null
      icon        = null
      format      = "date-time"
    }

    "fecha-actualizacion" = {
      title       = "Actualizado en"
      description = "Fecha y hora de la última actualización de la issue en New Relic"
      required    = false
      default     = null
      icon        = null
      format      = "date-time"
    }

    "nombre-flujo-trabajo" = {
      title       = "Nombre del workflow"
      description = "Nombre del workflow de New Relic que gestionó esta issue"
      required    = false
      default     = null
      icon        = null
      format      = null
    }
  }

  list_number_properties = {
    "total-incidentes" = {
      title       = "Total de incidentes"
      description = "Número total de incidentes asociados a esta issue"
      required    = false
      default     = null
      icon        = null
    }
  }

  list_boolean_properties = {
    "esta-relacionada" = {
      title       = "Está correlacionado"
      description = "Indica si la issue está correlacionada con otras issues"
      required    = false
      default     = null
      icon        = null
    }
  }

  list_array_properties = {
    fuentes = {
      title        = "Fuentes"
      description  = "Fuentes que originaron o están asociadas a la alerta"
      required     = false
      icon         = null
      string_items = {}
    }

    "nombres-politicas-alerta" = {
      title        = "Policies de alerta"
      description  = "Nombre de las policies de alerta asociadas a la issue"
      required     = false
      icon         = null
      string_items = {}
    }

    "entidades-impactadas" = {
      title        = "Entidades impactadas"
      description  = "Lista de entidades impactadas (servicios, workloads, etc.)"
      required     = false
      icon         = null
      string_items = {}
    }

    "nombres-condiciones-alerta" = {
      title        = "Condiciones de alerta"
      description  = "Condiciones de alerta que participaron en la generación de la issue"
      required     = false
      icon         = null
      string_items = {}
    }
  }

  # Sin relaciones por ahora (Bitbucket se conectará más adelante)
  has_relation = false
  force_delete_entities = true
}


module "new-relic-alert-webhook" {
  source     = "../modules/webhook"
  identifier = "nr-alert-webhook"
  title      = "NEW RELIC WEBHOOK ALERTA"
  icon       = "NewRelic"
  enabled    = true

  security = {
    secret                = local.newrelic_ingest_webhook_signature
    signature_header_name = "x-port-auth-newrelic"
    signature_algorithm   = "plain"
  }

  mappings = [
    {
      blueprint = module.new_relic_alert_webhook_blueprint.this.identifier
      operation = {
        type = "create"
      }
      filter = "true"

      entity = {
        identifier = ".body.id | tostring"
        title      = ".body.title"
        properties = {
          prioridad                    = ".body.priority"
          estado                       = ".body.state"
          "codigo-problema"            = ".body.id"
          "url-problema"               = ".body.issueUrl"
          "titulo-nr"                  = ".body.title"
          disparador                   = ".body.trigger"
          "fecha-creacion"             = ".body.createdAt / 1000 | todate"
          "fecha-actualizacion"        = ".body.updatedAt / 1000 | todate"
          "nombre-flujo-trabajo"       = ".body.workflowName"
          "total-incidentes"           = ".body.totalIncidents | tonumber"
          "esta-relacionada"           = ".body.isCorrelated"
          fuentes                      = ".body.sources"
          "nombres-politicas-alerta"   = ".body.alertPolicyNames"
          "entidades-impactadas"       = ".body.impactedEntities"
          "nombres-condiciones-alerta" = ".body.alertConditionNames"
        }
      }
    }
  ]
}
