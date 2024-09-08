resource "azurerm_consumption_budget_resource_group" "example" {
  name              = var.resource_group_budget_name
  resource_group_id = var.resource_group_id

  amount     = var.amount
  time_grain = var.time_grain

  time_period {
    start_date = "2022-06-01T00:00:00Z"
    end_date   = "2022-07-01T00:00:00Z"
  }
  dynamic "notification" {
    for_each = var.notifications
    content {
    operator        = notification.value.operator
    threshold       = notification.value.threshold
    threshold_type  = notification.value.threshold_type
    contact_emails  = notification.value.contact_emails
    contact_groups  = notification.value.contact_groups
    contact_roles   = notification.value.contact_roles
    enabled         = notification.value.enabled
    }
  }
}