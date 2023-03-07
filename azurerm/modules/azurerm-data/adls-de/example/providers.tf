terraform {
  backend "azurerm" {
    resource_group_name  = "exampletfstateresourcegroup"
    storage_account_name = "exampletfstate"
    container_name       = "tfstate"
    key                  = "example.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
