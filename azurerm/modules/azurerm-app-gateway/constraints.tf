terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
    }

    tls = {
    }

    acme = {
    }

    pkcs12 = {
      source = "chilicat/pkcs12"
    }
  }
}
