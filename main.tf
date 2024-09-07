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
    operator        = each.value.operator
    threshold       = each.value.threshold
    threshold_type  = each.value.threshold_type
    contact_emails  = each.value.contact_emails
    contact_groups  = each.value.contact_groups
    contact_roles   = each.value.contact_roles
    enabled         = each.value.enabled
    }
  }
}