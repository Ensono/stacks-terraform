terraform {
  backend "azurerm" {
    resource_group_name  = "tfstateresourcegroup"
    storage_account_name = "trishitfstaterishi"
    container_name       = "tfstate"
    key                  = "devlatestnewsql.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
