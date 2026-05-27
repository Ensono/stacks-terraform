terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    acme = {
      source = "vancluever/acme"
    }
    pkcs12 = {
      source = "chilicat/pkcs12"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}
