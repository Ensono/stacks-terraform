terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    #TODO: note this is just added right now without any use, can be used In future for databricks provider
    databricks = {
      source = "databricks/databricks"
    }
  }
}
