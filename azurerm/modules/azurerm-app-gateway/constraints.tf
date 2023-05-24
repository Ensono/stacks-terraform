terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    tls = {
      source = "hashicorp/tls"
    }

    acme = {
      source = "vancluever/acme"
    }

    pkcs12 = {
      source = "chilicat/pkcs12"
    }
  }
}
