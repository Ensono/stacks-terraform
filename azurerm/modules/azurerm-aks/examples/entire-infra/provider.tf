terraform {
  # NOTE: If you want a backend, uncomment this, else local will be used
  # backend "azurerm" {
  # }
}

provider "azurerm" {
  features {}
}
