terraform {
  required_version = ">= 1.5.1"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    tls = {
      source = "hashicorp/tls"
    }
  }
}
