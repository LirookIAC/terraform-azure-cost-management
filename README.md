# Azure Maintenance Configuration Module

## Overview
This module creates an Azure Maintenance Configuration resource. The maintenance configuration helps manage updates and patches for your Azure VMs Guest OS.

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
