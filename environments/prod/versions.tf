terraform {
  required_version = ">= 1.5"

  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = "~> 2.0"
    }
  }

  # Backend remoto recomendado para CI/CD (evita perder el state entre runs).
  # Descomenta y ajusta según tu proveedor de state, o inicializa con
  # `terraform init -backend-config=...` desde el workflow.
  #
  # backend "s3" {
  #   bucket = "nombre-del-bucket-state"
  #   key    = "port/prod/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "port" {
  client_id = var.port_client_id
  secret    = var.port_client_secret
  base_url  = var.port_base_url
}
