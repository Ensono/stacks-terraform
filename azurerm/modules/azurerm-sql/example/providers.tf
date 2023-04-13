terraform {
  backend "azurerm" {
    resource_group_name  = "tfstateresourcegroup"
    storage_account_name = "tfstaterishi"
    container_name       = "tfstate"
    key                  = "devsql.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
