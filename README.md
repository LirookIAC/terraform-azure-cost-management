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
  - **Description**: The name of the Resource Group Consumption Budget.
  - **Type**: `string`
  - **Validation**: Must not be empty.

- **`resource_group_id`**
  - **Description**: The ID of the Resource Group in the form of `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroup1`.
  - **Type**: `string`
  - **Validation**: Must be in the correct format `/subscriptions/{subscription-id}/resourceGroups/{resourceGroup}`.

- **`amount`**
  - **Description**: The total amount of cost to track with the budget.
  - **Type**: `number`
  - **Validation**: Must be greater than 0.

- **`time_grain`**
  - **Description**: The time covered by the budget. Must be one of `BillingAnnual`, `BillingMonth`, `BillingQuarter`, `Annually`, `Monthly`, `Quarterly`.
  - **Type**: `string`
  - **Default**: `Monthly`
  - **Validation**: Must be one of `BillingAnnual`, `BillingMonth`, `BillingQuarter`, `Annually`, `Monthly`, `Quarterly`.

- **`time_period`**
  - **Description**: The time period for the budget, including `start_date` and `end_date`. The `start_date` must be the first of the month, on or after June 1, 2017, and not more than 12 months in the future.
  - **Type**: `object`
    - **Attributes**:
      - **`start_date`**: `string`
      - **`end_date`**: `optional(string, "")`
  - **Validation**:
    - The `start_date` must be the first of the month in the format `YYYY-MM-01T00:00:00Z`.
    - The `start_date` must be on or after June 1, 2017.
    - The `start_date` must not be more than 12 months in the future.
    - If `end_date` is provided, it must be greater than the `start_date`.
    - If `end_date` is not set, the default end date is approximately 10 years from the `start_date`.

- **`notifications`**
  - **Description**: A list of notifications, each with its own set of parameters.
  - **Type**: `list(object({`
    - **`operator`**: `string`
    - **`threshold`**: `number`
    - **`threshold_type`**: `optional(string, "Actual")`
    - **`contact_emails`**: `optional(list(string), [])`
    - **`contact_groups`**: `optional(list(string), [])`
    - **`contact_roles`**: `optional(list(string), [])`
    - **`enabled`**: `optional(bool, true)`
  - **Validation**:
    - **Operator**: Must be one of `EqualTo`, `GreaterThan`, or `GreaterThanOrEqualTo`.
    - **Threshold**: Must be between `0` and `1000`.
    - **Threshold Type**: Must be one of `Actual` or `Forecasted`.
    - **Contact Details**: At least one of `contact_emails`, `contact_groups`, or `contact_roles` must be provided.
- **`dimensions`**
  - **Description**: A list of dimension filters to apply to the budget.
  - **Type**: `list(object({`
    - **`name`**: `string`
    - **`operator`**: `optional(string, "In")`  # Default value is "In"
    - **`values`**: `list(string)`
  - **Default**: 
    ```hcl
    [ 
      {
        name   = "ResourceId",
        values = ["unused_default_value"]
      } 
    ]
    ```
  - **Validation**:
    - **Name**: Each dimension's name must be one of the allowed values: `ChargeType`, `Frequency`, `InvoiceId`, `Meter`, `MeterCategory`, `MeterSubCategory`, `PartNumber`, `PricingModel`, `Product`, `ProductOrderId`, `ProductOrderName`, `PublisherType`, `ReservationId`, `ReservationName`, `ResourceGroupName`, `ResourceGuid`, `ResourceId`, `ResourceLocation`, `ResourceType`, `ServiceFamily`, `ServiceName`, `SubscriptionID`, `SubscriptionName`, `UnitOfMeasure`.
    - **Values**: Each dimension must specify at least one value in the `values` list.

- **`tags`**
  - **Description**: A list of tag filters to apply to the budget.
  - **Type**: `list(object({`
    - **`name`**: `string`
    - **`values`**: `list(string)`
  - **Default**: 
    ```hcl
    [ 
      {
        name   = "unused_default_value",
        values = ["unused_default_value"]
      } 
    ]
    ```
  - **Validation**:
    - **Values**: Each tag filter must specify at least one value in the `values` list.


