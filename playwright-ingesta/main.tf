module "repos_test" {
  source = "../modules/blueprint"

  identifier  = "repos_test"
  title       = "Repos-tests"
  icon        = "Github"
  description = "Repositorios de pruebas Playwright - DEV"
  force_delete_entities = true

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


module "playwright_report" {
  source = "../modules/blueprint"

  identifier  = "playwrightReport"
  title       = "Playwright Report"
  icon        = "Test"
  description = "Reportes de ejecución de pruebas Playwright - DEV"
  force_delete_entities = true

  list_string_properties = {
    repository = {
      title       = "Repository"
      description = "Repositorio donde se ejecutaron las pruebas."
      required    = false
    }

    organization = {
      title       = "Organization"
      description = "Organización de GitHub dueña del repositorio."
      required    = false
    }

    branch = {
      title       = "Branch"
      description = "Rama sobre la que se ejecutaron las pruebas."
      required    = false
    }

    commit = {
      title       = "Commit SHA"
      description = "SHA del commit ejecutado."
      required    = false
    }

    pipeline = {
      title       = "Pipeline / Workflow"
      description = "Pipeline o workflow que ejecutó las pruebas."
      required    = false
    }

    runUrl = {
      title       = "GitHub Run URL"
      description = "URL de la ejecución en GitHub Actions."
      format      = "url"
      required    = false
    }

    reportUrl = {
      title       = "HTML Report URL"
      description = "URL del reporte HTML de Playwright."
      format      = "url"
      required    = false
    }

    status = {
      title       = "Status"
      description = "Resultado global de la ejecución."
      enum        = ["passed", "failed", "flaky", "interrupted"]
      enum_colors = {
        passed      = "green"
        failed      = "red"
        flaky       = "orange"
        interrupted = "darkGray"
      }
      required = false
    }

    executedAt = {
      title       = "Executed At"
      description = "Fecha y hora de la ejecución."
      format      = "date-time"
      required    = false
    }

    summary = {
      title       = "Summary"
      description = "Resumen de la ejecución en markdown."
      format      = "markdown"
      required    = false
    }
  }

  list_number_properties = {
    runId = {
      title       = "GitHub Run ID"
      description = "ID de la ejecución en GitHub."
      required    = false
    }

    runNumber = {
      title       = "GitHub Run Number"
      description = "Número de la ejecución en GitHub."
      required    = false
    }

    durationMs = {
      title       = "Duration (ms)"
      description = "Duración total en milisegundos."
      required    = false
    }

    testsTotal = {
      title       = "Tests Total"
      description = "Total de tests ejecutados."
      required    = false
    }

    testsPassed = {
      title       = "Tests Passed"
      description = "Tests que pasaron."
      required    = false
    }

    testsFailed = {
      title       = "Tests Failed"
      description = "Tests que fallaron."
      required    = false
    }

    testsFlaky = {
      title       = "Tests Flaky"
      description = "Tests inestables (flaky)."
      required    = false
    }

    testsSkipped = {
      title       = "Tests Skipped"
      description = "Tests omitidos."
      required    = false
    }
  }

  list_array_properties = {
    browsers = {
      title       = "Browsers / Projects"
      description = "Navegadores o proyectos de Playwright ejecutados."
      required    = false
    }

    failedTests = {
      title       = "Failed Tests"
      description = "Lista de tests que fallaron."
      required    = false
    }

    tests = {
      title       = "Tests Detail"
      description = "List of tests with title, file, project, status, duration and error"
      required    = false
    }
  }

  list_calculation_properties = {
    passRate = {
      title       = "Pass Rate (%)"
      type        = "number"
      calculation = "if (.properties.testsTotal // 0) > 0 then (((.properties.testsPassed // 0) * 10000 / .properties.testsTotal | round) / 100) else null end"
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
  blueprint_identifier = "githubRepository"

  list_string_properties = {
    microfrontends = {
      description      = "Microfrontends a levantar (opcional)."
      title            = "Microfrontends a levantar"
      visible_jq_query = ".form.system_type == \"react-container\""
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
  url            = "https://api.github.com/repos/Banco-Exterior-CA/ing-plat-tools-playwright/actions/workflows/create-project.yml/dispatches"
  agent          = false
  synchronized   = false
  method         = "POST"

  headers = {
    Accept                 = "application/vnd.github+json"
    Authorization          = "Bearer {{ .secrets.TokenGithub }}"
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
  url            = "https://api.github.com/repos/Banco-Exterior-CA/ing-plat-tools-playwright/actions/workflows/run-tests.yml/dispatches"
  agent          = false
  synchronized   = false
  method         = "POST"

  headers = {
    Accept                 = "application/vnd.github+json"
    Authorization          = "Bearer {{ .secrets.TokenGithub }}"
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

#Catalogos



module "catalog_repositorios_playwright" {
  source = "../modules/Page"

  identifier  = "repositorios_playwright"
  title       = "Repositorios Playwright"
  type        = "blueprint-entities"
  description = "Catálogo de repositorios de pruebas Playwright."
  icon        = "Playwright"
  blueprint   = module.repos_test.identifier

  widgets = [
    {
      id          = "repositorios-playwright-table"
      type        = "table-entities-explorer"
      blueprint   = "repos_test"
      displayMode = "single"
      dataset = {
        combinator = "and"
        rules      = []
      }
    }
  ]

  page_filters = []
}



module "catalog_playwright_reports" {
  source = "../modules/Page"

  identifier  = "playwright_reports"
  title       = "Reportes Playwright"
  type        = "blueprint-entities"
  description = "Catálogo de reportes de ejecución de pruebas Playwright - DEV."
  icon        = "Test"
  blueprint   = module.playwright_report.identifier

  widgets = [
    {
      id          = "playwright-reports-table"
      type        = "table-entities-explorer"
      blueprint   = "playwrightReport"
      displayMode = "single"
      dataset = {
        combinator = "and"
        rules      = []
      }
    }
  ]

  page_filters = []
}




#Agente

module "agent_playwright_report" {
  source = "../modules/entity"

  identifier           = "playwright_report_agent"
  title                = "Playwright Report Agent"
  blueprint_identifier = "_ai_agent"

  string_props = {
    description    = "Registra informes de Playwright (GitHub Actions) en el blueprint playwrightReport."
    status         = "active"
    execution_mode = "Automatic"
    prompt         = <<-EOT
      Eres el agente que registra informes de Playwright en Port. Recibiras el contenido del informe y metadatos de GitHub Actions (organizacion, repositorio, branch, commit, runId, runNumber, runUrl, workflow, reportUrl). Crea o actualiza UNA entidad en el blueprint playwrightReport con upsert_entity. Identifier: <repositorio>-<runId> en minusculas. Title: <workflow> #<runNumber> - <repositorio>. Rellena: organization, repository, branch, commit, pipeline, runId, runNumber, runUrl, reportUrl, executedAt (ISO 8601), durationMs, testsTotal, testsPassed, testsFailed, testsSkipped, testsFlaky, browsers (array), failedTests (array 'archivo > titulo'), tests (array de objetos con title, file, project, status, durationMs, error) y summary (markdown). status: failed si testsFailed>0; flaky si no hay fallos pero testsFlaky>0; interrupted si se interrumpio; si no passed. No inventes datos: si un valor no esta en el informe, omitelo. No modifiques otros blueprints. Al terminar responde con el identifier creado y un resumen de 1-2 lineas.
    EOT
  }

  array_props = {
    string_items = {
      tools = [
        "^(list|get|search)_.*",
        "^upsert_entity$"
      ]
    }
  }

  many_relations = {
    mcp_servers = []
  }
}
