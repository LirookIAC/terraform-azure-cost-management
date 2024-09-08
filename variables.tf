
variable "resource_group_budget_name" {
  description = "The name of the Resource Group Consumption Budget."
  type        = string

  validation {
    condition     = length(var.resource_group_budget_name) > 0
    error_message = "The resource group budget name must not be empty."
  }
}

variable "resource_group_id" {
  description = "The ID of the Resource Group in the form of '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroup1'."
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-fA-F-]+/resourceGroups/[a-zA-Z0-9-_]+$", var.resource_group_id))
    error_message = "The resource_group_id must be in the form '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroup1'."
  }
}

# Variable for the budget amount
variable "amount" {
  description = "The total amount of cost to track with the budget."
  type        = number

  validation {
    condition     = var.amount > 0
    error_message = "The budget amount must be a positive number."
  }
}

variable "time_grain" {
  description = "The time covered by the budget. Must be one of BillingAnnual, BillingMonth, BillingQuarter, Annually, Monthly, Quarterly."
  type        = string
  default     = "Monthly"

  validation {
    condition     = contains(["BillingAnnual", "BillingMonth", "BillingQuarter", "Annually", "Monthly", "Quarterly"], var.time_grain)
    error_message = "time_grain must be one of BillingAnnual, BillingMonth, BillingQuarter, Annually, Monthly, Quarterly."
  }
}

variable "time_period" {
  description = "The time period for the budget, including start_date and end_date. The start date must be the first of the month, on or after June 1, 2017, and not more than 12 months in the future."

  type = object({
    start_date = string
    end_date   = optional(string, "")
  })

  validation {
    condition = (
      can(regex("^\\d{4}-\\d{2}-01T\\d{2}:\\d{2}:\\d{2}Z$", var.time_period.start_date)) &&
      
      # Ensure start_date is on or after June 1, 2017
      timecmp(var.time_period.start_date, "2017-06-01T00:00:00Z") >= 0 &&
      
      # Ensure start_date is not more than 12 months in the future
      timecmp(var.time_period.start_date, formatdate("YYYY-MM-DDTHH:MM:SSZ", timeadd(timestamp(), "8760h"))) <= 0 &&
      # Ensure start_date is less than end_date if end_date is provided
      (var.time_period.end_date == "" || timecmp(var.time_period.start_date, var.time_period.end_date) < 0)
    )
    error_message = "The start_date must be the first of the month, on or after June 1, 2017, and not more than 12 months in the future. The start_date must also be less than the end_date if end_date is provided."
  }
}



variable "notifications" {
  description = "A map of notifications, each with its own set of parameters."
  type = map(object({
    operator        = string
    threshold       = number
    threshold_type  = optional(string, "Actual")
    contact_emails  = optional(list(string), [])
    contact_groups  = optional(list(string), [])
    contact_roles   = optional(list(string), [])
    enabled         = optional(bool, true)
  }))

  validation {
    condition = alltrue([
      for n in values(var.notifications) : (
        n.operator == "EqualTo" || n.operator == "GreaterThan" || n.operator == "GreaterThanOrEqualTo"
      )
    ])
    error_message = "The operator must be one of 'EqualTo', 'GreaterThan', or 'GreaterThanOrEqualTo'."
  }

  validation {
    condition = alltrue([
      for n in values(var.notifications) : (
        n.threshold >= 0 && n.threshold <= 1000
      )
    ])
    error_message = "The threshold value must be between 0 and 1000."
  }
  validation {
    condition = alltrue([
      for n in values(var.notifications) : (
        n.threshold_type == "Actual" || n.threshold_type == "Forecasted"
      )
    ])
    error_message = "The threshold_type must be one of 'Actual' or 'Forecasted'."
  }
}

