resource "port_page" "this" {
  identifier  = var.identifier
  title       = var.title
  type        = var.type
  description = var.description
  icon        = var.icon
  blueprint   = var.blueprint
  parent      = var.parent
  after       = var.after
  locked      = var.locked

  widgets = [
    for widget in var.widgets : jsonencode(widget)
  ]

  page_filters = [
    for page_filter in var.page_filters : jsonencode(page_filter)
  ]
}