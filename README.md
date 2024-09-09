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
