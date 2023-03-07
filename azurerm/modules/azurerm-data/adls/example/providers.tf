terraform {
  backend "azurerm" {
    resource_group_name  = "jakub-sandbox"
    storage_account_name = "jakubsandboxtfstate"
    container_name       = "tfstate"
    key                  = "example.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
