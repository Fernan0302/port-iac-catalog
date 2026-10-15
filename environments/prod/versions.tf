terraform {
  cloud {
    organization = "Banco-Exterior"

    workspaces {
      name = "port-dev"
    }
  }

  required_version = ">= 1.5"

  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = "~> 2.0"
    }
  }
}

provider "port" {
  client_id = var.port_client_id
  secret    = var.port_client_secret
  base_url  = var.port_base_url
}