terraform {
  backend "azurerm" {
    resource_group_name  = "amido-stacks-dev-euw-de"
    storage_account_name = "detestdevrb"
    container_name       = "tfstate"
    key                  = "vmss.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
