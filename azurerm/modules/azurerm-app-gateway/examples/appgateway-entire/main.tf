locals {
  vnet_cidr = ["10.20.0.0/16"]
}

module "key_vault_app_gateway" {
  source = "../../"

  resource_namer          = "example-appgw-kv"
  resource_group_name     = "rg-example-network"
  resource_group_location = "uksouth"

  vnet_name                 = "vnet-example-network"
  vnet_cidr                 = local.vnet_cidr
  subnet_front_end_prefix   = cidrsubnet(local.vnet_cidr[0], 8, 0)
  subnet_backend_end_prefix = cidrsubnet(local.vnet_cidr[0], 8, 1)

  dns_zone = "apps.example.invalid"

  aks_resource_group = "rg-example-aks"
  aks_ingress_ip     = "10.20.1.4"

  certificate_source  = "key_vault"
  key_vault_secret_id = "https://example-kv.vault.azure.net/secrets/app-gateway-tls"
  identity_type       = "UserAssigned"
  user_assigned_identity_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-identity/providers/Microsoft.ManagedIdentity/userAssignedIdentities/app-gateway-kv-reader"
  ]
}
