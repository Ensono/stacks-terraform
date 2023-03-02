terraform {
  backend "azurerm" {
    resource_group_name  = "tfstateresourcegroup"
    storage_account_name = "tfstaterishi"
    container_name       = "tfstate"
    key                  = "rishi.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}

