terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstateresourcegroup"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "lates.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
