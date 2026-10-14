module "repos_test" {
  source = "../modules/blueprint"

  identifier  = "repos_test"
  title       = "Repos-tests"
  icon        = "Github"
  description = "Repositorios de pruebas Playwright - DEV"

  list_string_properties = {
    nombre = {
      title       = "Nombre"
      description = "Nombre del repositorio de pruebas Playwright."
      required    = true
    }

    rama = {
      title       = "Rama"
      description = "Rama del repositorio de pruebas a ejecutar."
      default     = "main"
      required    = true
    }

    url = {
      title       = "URL"
      description = "URL del repositorio de GitHub."
      required    = false
    }
  }
}

module "creacion_proyecto_playwright" {
  source = "../modules/action"

  identifier  = "creacion_proyecto_playwright4"
  title       = "Creación de proyecto Playwright4"
  icon        = "Github"
  description = "Crea un proyecto Playwright mediante un workflow de GitHub Actions."

  self_service_trigger = true
  operation            = "DAY-2"
  blueprint_identifier = "listadoRepoGitHub"

  list_string_properties = {
    microfrontends = {
      description = "Microfrontends a levantar (opcional)."
      title       = "Microfrontends a levantar"
    }
    ref = {
      default     = "main"
      description = "Branch o ref sobre la que se ejecutará el workflow."
      disabled    = true
      title       = "Branch / Ref"
    }
    repository_name = {
      description = "Nombre del repositorio Playwright a crear."
      title       = "Nombre del repositorio"
      required    = true
    }
    system_repository = {
      default_jq_query = ".entity.title"
      description      = "Repositorio del sistema que será probado."
      title            = "Repositorio del sistema"
      required         = true
    }
    system_type = {
      description = "Tecnología del sistema a probar."
      enum        = ["java-backend", "react-container", "react-microfront"]
      title       = "Tipo de sistema"
      required    = true
    }
    visibility = {
      default     = "private"
      description = "Visibilidad del repositorio a crear."
      enum        = ["private", "internal", "public"]
      title       = "Visibilidad"
      required    = true
    }
  }

  order_properties = [
    "ref",
    "repository_name",
    "system_type",
    "system_repository",
    "microfrontends",
    "visibility"
  ]

  webhook_method = true
  url            = "https://api.github.com/repos/abastimo/playwright-quickstart/actions/workflows/create-project.yml/dispatches"
  agent          = false
  synchronized   = false
  method         = "POST"

  headers = {
    Accept                 = "application/vnd.github+json"
    Authorization          = "Bearer {{ .secrets.Secret_Playwright }}"
    "Content-Type"         = "application/json"
    RUN_ID                 = "{{ .run.id }}"
    "X-GitHub-Api-Version" = "2022-11-28"
  }

  body_webhook_method = jsonencode({
    inputs = {
      microfrontends    = "{{.inputs.microfrontends // \"\"}}"
      port_run_id       = "{{.run.id}}"
      repository_name   = "{{.inputs.repository_name}}"
      system_repository = "{{.inputs.system_repository}}"
      system_type       = "{{.inputs.system_type}}"
      visibility        = "{{.inputs.visibility}}"
    }
    ref = "{{.inputs.ref}}"
  })

  required_approval = false
}



module "pruebas_playwright" {
  source = "../modules/action"

  identifier  = "pruebas_playwright4"
  title       = "Pruebas Playwright4"
  icon        = "Github"
  description = "Ejecuta las pruebas Playwright de un repositorio mediante un workflow de GitHub Actions."

  self_service_trigger = true
  operation            = "DAY-2"
  blueprint_identifier = module.repos_test.identifier

  list_string_properties = {
    grep = {
      title       = "Filtro pruebas"
      description = "Filtro de pruebas a ejecutar (opcional). Equivale a --grep de Playwright."
    }

    target_ref = {
      title            = "Rama"
      default_jq_query = ".entity.properties.rama"
      description      = "Rama del repositorio de pruebas a ejecutar."
      required         = true
    }

    test_repo = {
      title            = "Repositorio pruebas a ejecutar"
      default_jq_query = ".entity.properties.nombre"
      description      = "Repositorio que contiene las pruebas a ejecutar."
      required         = true
    }
    use_agent = {
      title       = "Usar agente de Port"
      description = "Selecciona si se utiliza el agente de Port para registrar el informe."
      enum        = ["si", "no"]
      default     = "si"
    }
  }

  order_properties = [
    "test_repo",
    "target_ref",
    "grep",
    "use_agent"
  ]

  webhook_method = true
  url            = "https://api.github.com/repos/abastimo/playwright-quickstart/actions/workflows/run-tests.yml/dispatches"
  agent          = false
  synchronized   = false
  method         = "POST"

  headers = {
    Accept                 = "application/vnd.github+json"
    Authorization          = "Bearer {{ .secrets.Secret_Playwright }}"
    "Content-Type"         = "application/json"
    RUN_ID                 = "{{ .run.id }}"
    "X-GitHub-Api-Version" = "2022-11-28"
  }

  body_webhook_method = jsonencode({
    inputs = {
      grep        = "{{.inputs.grep // \"\"}}"
      port_run_id = "{{.run.id}}"
      target_ref  = "{{.inputs.target_ref}}"
      test_repo   = "{{.inputs.test_repo}}"
      use_agent   = "{{.inputs.use_agent // \"\"}}"
    }
    ref = "main"
  })

  required_approval = false
}
