

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


# module "demo_page" {
# source = "../modules/page"

# identifier  = "demo-dashboard"
# title       = "Demo Dashboard"
# description = "Página de prueba creada con Terraform"
# icon        = "Dashboard"
# type        = "dashboard"

# widgets = [
# jsonencode({
# id   = "demo-dashboard-widget"
# type = "dashboard-widget"

#   layout = [
#     {
#       height = 400

#       columns = [
#         {
#           id   = "demo-markdown"
#           size = 12
#         }
#       ]
#     }
#   ]

#   widgets = [
#     {
#       id          = "demo-markdown"
#       type        = "markdown"
#       title       = "Bienvenida"
#       icon        = "BlankPage"
#       description = ""
#       markdown    = "# Hola\n\nEsta página fue creada desde Terraform."
#     }
#   ]
# })

# ]
# }


# module "checkmarx_page" {
#   source = "../modules/Page"

#   identifier  = "checkmarx-demo"
#   title       = "Checkmarx Demo"
#   icon        = "Apps"
#   type        = "dashboard"
#   parent      = "seguridad"
#   locked      = true
#   description = ""

#   widgets = [
#     {
#       id   = "checkmarx-dashboard"
#       type = "dashboard-widget"

#       layout = [
#         {
#           height = 400

#           columns = [
#             {
#               id   = "checkmarx-table"
#               size = 12
#             }
#           ]
#         },
#         {
#           height = 400

#           columns = [
#             {
#               id   = "security-maturity-pie"
#               size = 6
#             },
#             {
#               id   = "scan-by-project-pie"
#               size = 6
#             }
#           ]
#         }
#       ]

#       widgets = [

#         # ============================================================
#         # 1. TABLA - ANALISIS CHECKMARX
#         # ============================================================
#         {
#           id             = "checkmarx-table"
#           type           = "table-entities-explorer"
#           displayMode    = "widget"
#           title          = "Análisis Checkmarx"
#           excludedFields = []
#           description    = ""
#           emptyStateText = ""
#           icon           = "Table"
#           blueprint      = "checkmarxScan"

#           dataset = {
#             combinator = "and"
#             rules      = []
#           }

#           blueprintConfig = {
#             checkmarxScan = {
#               filterSettings = {
#                 filterBy = {
#                   combinator = "and"
#                   rules      = []
#                 }
#               }

#               groupSettings = {
#                 groupBy = []
#               }

#               sortSettings = {
#                 sortBy = [
#                   {
#                     property = "createdAt"
#                     order    = "desc"
#                   }
#                 ]
#               }

#               propertiesSettings = {
#                 order = []

#                 shown = [
#                   "$identifier",
#                   "$updatedAt",
#                   "$createdAt",
#                   "$title",
#                   "status",
#                   "branch",
#                   "createdAt",
#                   "updatedAt",
#                   "projectId",
#                   "repoUrl"
#                 ]
#               }
#             }
#           }
#         },

#         # ============================================================
#         # 2. PIE - DEMO MADUREZ SEGURIDAD
#         # ============================================================
#         {
#           id             = "security-maturity-pie"
#           type           = "entities-pie-chart"
#           blueprint      = "checkmarxScan"
#           title          = "Demo Madurez Seguridad"
#           description    = ""
#           emptyStateText = ""
#           icon           = "Pie"

#           property = "scorecard#madurez_seguridad"

#           dataset = {
#             combinator = "and"
#             rules      = []
#           }
#         },

#         # ============================================================
#         # 3. PIE - ESCAN POR PROYECTO
#         # ============================================================
#         {
#           id             = "scan-by-project-pie"
#           type           = "entities-pie-chart"
#           blueprint      = "checkmarxScan"
#           title          = "Escan por proyecto"
#           description    = ""
#           emptyStateText = ""
#           icon           = "Pie"

#           property = "property#projectId"

#           dataset = {
#             combinator = "and"
#             rules      = []
#           }
#         }
#       ]
#     }
#   ]
# }

# module "platform_service" {
#   source = "../modules/blueprint"

#   identifier  = "platform_ingesta"
#   title       = "Platform ingesta"
#   description = "Blueprint para el catálogo de servicios de plataforma conectado con AWS"
#   icon        = "Microservices"

#   create_catalog_page   = true
#   force_delete_entities = false

#   list_string_properties = {
#     repository = {
#       title       = "Repository"
#       description = "Repositorio del servicio"
#       required    = true
#     }

#     branch = {
#       title       = "Branch"
#       description = "Rama del repositorio"
#       required    = true
#     }

#     environment = {
#       title       = "Environment"
#       description = "Ambiente del servicio"
#       required    = true
#     }

#     pipelineStatus = {
#       title       = "Pipeline Status"
#       description = "Estado del pipeline"
#       required    = true
#     }

#     sonarQualityGate = {
#       title       = "Sonar Quality Gate"
#       description = "Resultado del Quality Gate de SonarQube"
#     }
#   }

#   list_number_properties = {
#     sonarCoverage = {
#       title       = "Sonar Coverage"
#       description = "Porcentaje de cobertura de código"
#     }

#     sonarBugs = {
#       title       = "Sonar Bugs"
#       description = "Cantidad de bugs encontrados por SonarQube"
#     }

#     sonarVulnerabilities = {
#       title       = "Sonar Vulnerabilities"
#       description = "Cantidad de vulnerabilidades encontradas por SonarQube"
#     }

#     sonarCodeSmells = {
#       title       = "Sonar Code Smells"
#       description = "Cantidad de code smells encontrados por SonarQube"
#     }

#     checkmarxCritical = {
#       title       = "Checkmarx Critical"
#       description = "Vulnerabilidades críticas encontradas por Checkmarx"
#     }

#     checkmarxHigh = {
#       title       = "Checkmarx High"
#       description = "Vulnerabilidades altas encontradas por Checkmarx"
#     }

#     checkmarxMedium = {
#       title       = "Checkmarx Medium"
#       description = "Vulnerabilidades medias encontradas por Checkmarx"
#     }

#     newRelicResponseTime = {
#       title       = "New Relic Response Time"
#       description = "Tiempo de respuesta en milisegundos"
#     }

#     newRelicErrorRate = {
#       title       = "New Relic Error Rate"
#       description = "Porcentaje de errores"
#     }

#     newRelicApdex = {
#       title       = "New Relic Apdex"
#       description = "Indicador Apdex de New Relic"
#     }
#   }

#   module "pruebas_playwright" {
#   source = "../modules/action"

#   identifier  = "pruebas_playwright4"
#   title       = "Pruebas Playwright4"
#   icon        = "Github"
#   description = "Ejecuta las pruebas Playwright de un repositorio mediante un workflow de GitHub Actions."

#   self_service_trigger = true
#   operation            = "DAY-2"
#   blueprint_identifier = module.repos_test.identifier

#   list_string_properties = {
#     grep = {
#       title       = "Filtro pruebas"
#       description = "Filtro de pruebas a ejecutar (opcional). Equivale a --grep de Playwright."
#     }

#     target_ref = {
#       title            = "Rama"
#       default_jq_query = ".entity.properties.rama"
#       description      = "Rama del repositorio de pruebas a ejecutar."
#       required         = true
#     }

#     test_repo = {
#       title            = "Repositorio pruebas a ejecutar"
#       default_jq_query = ".entity.properties.nombre"
#       description      = "Repositorio que contiene las pruebas a ejecutar."
#       required         = true
#     }
#     use_agent = {
#       title       = "Usar agente de Port"
#       description = "Selecciona si se utiliza el agente de Port para registrar el informe."
#       enum        = ["si", "no"]
#       default     = "si"
#     }
#   }

#   order_properties = [
#     "test_repo",
#     "target_ref",
#     "grep",
#     "use_agent"
#   ]

#   webhook_method = true
#   url            = "https://api.github.com/repos/abastimo/playwright-quickstart/actions/workflows/run-tests.yml/dispatches"
#   agent          = false
#   synchronized   = false
#   method         = "POST"

#   headers = {
#     Accept                 = "application/vnd.github+json"
#     Authorization          = "Bearer {{ .secrets.Secret_Playwright }}"
#     "Content-Type"         = "application/json"
#     RUN_ID                 = "{{ .run.id }}"
#     "X-GitHub-Api-Version" = "2022-11-28"
#   }

#   body_webhook_method = jsonencode({
#     inputs = {
#       grep        = "{{.inputs.grep // \"\"}}"
#       port_run_id = "{{.run.id}}"
#       target_ref  = "{{.inputs.target_ref}}"
#       test_repo   = "{{.inputs.test_repo}}"
#       use_agent   = "{{.inputs.use_agent // \"\"}}"
#     }
#     ref = "main"
#   })

#   required_approval = false
# }
