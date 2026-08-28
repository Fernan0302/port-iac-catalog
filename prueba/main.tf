

# # module "folder" {
# #   source = "../modules/folder"

# #   identifier = "arquitectura"
# #   title      = "Arquitectura"
# # }

# module "environment_blueprint" {
# source = "../modules/blueprint"

# identifier  = "demo-environment2"
# title       = "Demo Environment2"
# icon        = "Cloud"
# description = "[DEMO] Ambiente de infraestructura (dev/staging/prod) — ejemplo del pipeline port-iac-catalog"

# list_string_properties = {
# "region" = {
# title       = "Región"
# description = "Región donde vive el ambiente"
# required    = true
# }


# "status" = {
#   title    = "Estado"
#   required = true
#   enum     = ["active", "provisioning", "decommissioning"]
# }

# }
# }

# module "github_webhook" {
# source = "../modules/webhook"

# identifier = "github-pull-request"
# title      = "GitHub Pull Request"
# icon       = "GitHub"
# enabled    = true

# mappings = [
# {
# blueprint = module.environment_blueprint.identifier


#   operation = {
#     type = "create"
#   }

#   entity = {
#     identifier = ".body.id | tostring"
#     title      = ".body.title"

#     properties = {
#       region = ".body.region"
#       status = ".body.status"
#     }
#   }
# }


# ]
# }


module "demo_page" {
source = "../modules/page"

identifier  = "demo-dashboard"
title       = "Demo Dashboard"
description = "Página de prueba creada con Terraform"
icon        = "Dashboard"
type        = "dashboard"

widgets = [
jsonencode({
id   = "demo-dashboard-widget"
type = "dashboard-widget"

  layout = [
    {
      height = 400

      columns = [
        {
          id   = "demo-markdown"
          size = 12
        }
      ]
    }
  ]

  widgets = [
    {
      id          = "demo-markdown"
      type        = "markdown"
      title       = "Bienvenida"
      icon        = "BlankPage"
      description = ""
      markdown    = "# Hola\n\nEsta página fue creada desde Terraform."
    }
  ]
})

]
}
