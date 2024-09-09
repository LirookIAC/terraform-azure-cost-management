# Azure Consumption Budget Resource Group Module

## Overview
This module creates an Azure Consumption Budget resource for a specified resource group. It helps manage and monitor budget thresholds for Azure resources within the resource group.

## Version Constraints

To ensure compatibility with this module, the following version constraints apply:

```hcl
terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.112.0, < 4.0.0"
    }
  }
}
```
- Terraform: Tested with version 1.7.5  
- AzureRM Provider: Tested with version 3.116.0

## Outputs

This module provides the following output:

```hcl
output "resource_group_budget_id" {
  value = azurerm_consumption_budget_resource_group.lirook.id
}
```
- resource_group_budget_id: The ID of the created Azure Consumption Budget resource for the specified resource group. This section details the output variable provided by the module and its purpose.

- ## Usage

To use this module, follow these steps:

1. **Define Module Source**

   Specify the source path or URL of the module in your Terraform configuration. This could be a local path or a remote repository.

   ```hcl
   module "resource_group_budget" {
     source = "path_to_module_or_repository"
   }
   ```

2. **Set Required Variables**

   Configure the following variables to tailor the budget resource to your needs:

   - **`resource_group_budget_name`**
     - Description: The name of the Resource Group Consumption Budget.
     - Type: `string`
     - Validation: Must not be empty.

   - **`resource_group_id`**
     - Description: The ID of the Resource Group in the form of `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroup1`.
     - Type: `string`
     - Validation: Must be in the correct format `/subscriptions/{subscription-id}/resourceGroups/{resourceGroup}`.

   - **`amount`**
     - Description: The total amount of cost to track with the budget.
     - Type: `number`
     - Validation: Must be greater than 0.

   - **`time_grain`**
     - Description: The time grain at which the budget is tracked (e.g., "Monthly", "Quarterly").
     - Type: `string`
     - Validation: Must be one of ["Monthly", "Quarterly", "Annually"].

   - **`start_date`**
     - Description: The start date for the budget tracking in the format `YYYY-MM-DD`.
     - Type: `string`
     - Validation: Must be a valid date string.

   - **`end_date`**
     - Description: The end date for the budget tracking in the format `YYYY-MM-DD`.
     - Type: `string`
     - Validation: Optional. If not provided, the budget will continue indefinitely.

   - **`notifications_enabled`**
     - Description: Whether notifications for budget thresholds are enabled.
     - Type: `bool`
     - Default: `true`.

   - **`thresholds`**
     - Description: A list of thresholds (as percentages) that trigger budget notifications.
     - Type: `list(number)`
     - Validation: Must be a list of numbers between 0 and 100.
     
   - **`contact_emails`**
     - Description: A list of email addresses to receive budget notifications.
     - Type: `list(string)`
     - Validation: Must be a list of valid email addresses.
