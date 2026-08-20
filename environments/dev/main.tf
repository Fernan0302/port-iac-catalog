
# Compone los módulos de blueprint/entity para
# desplegar un catálogo de ejemplo en Port.


# --- Blueprint 1: Demo Environment ---------------------------------------
module "environment_blueprint" {
  source = "../../modules/blueprint"

  identifier  = "demo-environment"
  title       = "Demo Environment"
  icon        = "Cloud"
  description = "[DEMO] Ambiente de infraestructura (dev/staging/prod) — ejemplo del pipeline port-iac-catalog"

  string_props = {
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

  string_props = {
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

  relations = {
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
