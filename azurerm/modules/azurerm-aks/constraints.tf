terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.5"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 2.1"
    }
  }
}
