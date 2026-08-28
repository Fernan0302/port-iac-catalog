resource "port_page" "this" {
identifier = var.identifier
type       = var.type

title        = var.title
description  = var.description
icon         = var.icon
locked       = var.locked
blueprint    = var.blueprint
parent       = var.parent
after        = var.after
page_filters = var.page_filters
widgets      = var.widgets
}
