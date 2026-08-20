# Compone los módulos de blueprint/entity/action para
# desplegar un catálogo de ejemplo en Port.

# --- Blueprint 1: Demo Environment ---------------------------------------
module "environment_blueprint" {
  source = "../../modules/blueprint"

  identifier  = "demo-environment"
  title       = "Demo Environment"
  icon        = "Cloud"
  description = "[DEMO] Ambiente de infraestructura (dev/staging/prod) — ejemplo del pipeline port-iac-catalog"

  list_string_properties = {
    "region" = {
      title       = "Región"
      description = "Región donde vive el ambiente"
      required    = true
    }
    "status" = {
      title    = "Estado"
      required = true
      enum     = ["active", "provisioning", "decommissioning"]
    }
  }
}

# --- Blueprint 2: Demo Service (con relación hacia Demo Environment) -----
module "service_blueprint" {
  source = "../../modules/blueprint"

  identifier  = "demo-service"
  title       = "Demo Service"
  icon        = "Service"
  description = "[DEMO] Servicio de software del catálogo — ejemplo del pipeline port-iac-catalog"

  list_string_properties = {
    "language" = {
      title    = "Lenguaje"
      required = false
    }
    "repo_url" = {
      title    = "Repositorio"
      format   = "url"
      required = false
    }
  }

  has_relation = true
  list_relations = {
    "environment" = {
      title    = "Environment"
      target   = module.environment_blueprint.identifier
      required = true
      many     = false
    }
  }
}

# --- Entidad de ejemplo: Demo Environment "dev" -------------------------
module "dev_environment_entity" {
  source = "../../modules/entity"

  identifier            = "demo-dev"
  title                 = "Demo Development"
  blueprint_identifier  = module.environment_blueprint.identifier

  string_props = {
    "region" = "us-east-1"
    "status" = "active"
  }
}

# --- Entidad de ejemplo: Demo Service "example-service" ------------------
module "example_service_entity" {
  source = "../../modules/entity"

  identifier           = "demo-example-service"
  title                = "Demo Example Service"
  blueprint_identifier = module.service_blueprint.identifier

  string_props = {
    "language" = "Go"
    "repo_url" = "https://github.com/org/example-service"
  }

  single_relations = {
    "environment" = module.dev_environment_entity.identifier
  }
}

# --- Action de ejemplo: self-service "Scaffold Service" ------------------
module "scaffold_service_action" {
  source = "../../modules/action"

  identifier  = "demo_scaffold_service"
  title       = "Scaffold Service"
  icon        = "Service"
  description = "[DEMO] Crea un nuevo Demo Service en el catálogo desde un formulario self-service."
  publish     = true

  self_service_trigger = true
  operation             = "CREATE"
  blueprint_identifier   = module.service_blueprint.identifier

  list_string_properties = {
    "language" = {
      title    = "Lenguaje"
      required = true
    }
    "repo_url" = {
      title    = "Repositorio"
      format   = "url"
      required = true
    }
  }
  order_properties = ["language", "repo_url"]

  # Backend: registra la entidad directamente en Port al ejecutar la acción
  upsert_entity_method                = true
  upsert_entity_blueprint_identifier  = module.service_blueprint.identifier
  upsert_entity_title                 = "{{.inputs.\"repo_url\"}}"
  mapping_entity = {
    string_props = {
      "language" = "{{.inputs.\"language\"}}"
      "repo_url" = "{{.inputs.\"repo_url\"}}"
    }
  }
}
