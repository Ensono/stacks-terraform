terraform {
  backend "azurerm" {
    resource_group_name  = "tfstateresourcegroup"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
