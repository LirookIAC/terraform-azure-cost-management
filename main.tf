resource "azurerm_consumption_budget_resource_group" "lirook" {
  name              = var.resource_group_budget_name
  resource_group_id = var.resource_group_id

  amount     = var.amount
  time_grain = var.time_grain

  time_period {
    start_date = var.time_period.start_date
    end_date   = var.time_period.end_date != "" ? var.time_period.end_date : timeadd(var.time_period.start_date, "87600h")
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
  dynamic "filter"{
    for_each = var.dimensions[0].values[0] == "unused_default_value" && var.tags[0].name == "unused_default_value" ? [] : [1]
    content {
    dynamic "dimension" {
        for_each = var.dimensions[0].values[0] == "unused_default_value"? [] : var.dimensions
        content {
          name = dimension.value.name
          values = dimension.value.values        
        }
      }

      dynamic "tag" {
        for_each = var.tags[0].name == "unused_default_value"? [] : var.tags
        content {
          name = tag.value.name
          values = tag.value.values
        }
      }
    }
  }
}