##################################################
# Ambiente: prod
# Misma composición de módulos que dev; ajusta
# valores según el entorno productivo real.
##################################################

module "environment_blueprint" {
  source = "../../modules/blueprint"

  identifier  = "environment"
  title       = "Environment"
  icon        = "Cloud"
  description = "Ambiente de infraestructura (dev/staging/prod)"

  string_props = {
    "region" = {
      title    = "Región"
      required = true
    }
    "status" = {
      title    = "Estado"
      required = true
      enum     = ["active", "provisioning", "decommissioning"]
    }
  }
}

module "service_blueprint" {
  source = "../../modules/blueprint"

  identifier  = "service"
  title       = "Service"
  icon        = "Service"
  description = "Servicio de software del catálogo"

  string_props = {
    "language" = { title = "Lenguaje" }
    "repo_url" = { title = "Repositorio", format = "url" }
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

module "prod_environment_entity" {
  source = "../../modules/entity"

  identifier           = "production"
  title                = "Production"
  blueprint_identifier = module.environment_blueprint.identifier

  string_props = {
    "region" = "us-east-1"
    "status" = "active"
  }
}
