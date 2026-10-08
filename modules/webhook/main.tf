resource "port_webhook" "this" {
identifier  = var.identifier
title       = var.title
description = var.description
icon        = var.icon
enabled     = var.enabled

mappings = var.mappings
security = var.security
}
