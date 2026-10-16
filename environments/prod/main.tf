module "newrelic_ingesta" {
  source = "../../newrelic-ingesta"

  newrelic_ingest_webhook_signature = var.newrelic_ingest_webhook_signature
}

module "playwright_ingesta" {
  source = "../../playwright-ingesta"

}


