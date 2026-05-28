locals {
  vnet_cidr = ["10.10.0.0/16"]
}

module "legacy_acme_app_gateway" {
  source = "../../"

  resource_namer          = "example-appgw-acme"
  resource_group_name     = "rg-example-network"
  resource_group_location = "uksouth"

  vnet_name                 = "vnet-example-network"
  vnet_cidr                 = local.vnet_cidr
  subnet_front_end_prefix   = cidrsubnet(local.vnet_cidr[0], 8, 0)
  subnet_backend_end_prefix = cidrsubnet(local.vnet_cidr[0], 8, 1)

  dns_zone              = "apps.example.invalid"
  dns_resource_group    = "rg-example-dns"
  azure_subscription_id = "00000000-0000-0000-0000-000000000000"
  acme_email            = "platform@example.invalid"
  pfx_password          = "Password1"

  aks_resource_group = "rg-example-aks"
  aks_ingress_ip     = "10.10.1.4"
}
