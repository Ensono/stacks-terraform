output "vnet_name" {
  description = "Created VNET name.\nName can be deduced however it's better to create a direct dependency"
  value       = var.create_aksvnet ? module.aks_bootstrap.vnet_name : ""
}

output "vnet_address_space" {
  description = "Specified VNET address space"
  value       = var.create_aksvnet ? module.aks_bootstrap.vnet_address_space : []
}

output "vnet_address_id" {
  description = "Specified VNET Id"
  value       = var.create_aksvnet ? module.aks_bootstrap.vnet_address_id : ""
}

output "resource_group_name" {
  description = "Created resource group Name"
  value       = module.aks_bootstrap.resource_group_name
}

output "resource_group_id" {
  description = "Created resource group Id"
  value       = module.aks_bootstrap.resource_group_id
}

# output "aks_vmss" {
#   value = azurerm_kubernetes_cluster.default.
# }

output "aks_node_resource_group" {
  value = module.aks_bootstrap.aks_node_resource_group
}

output "aks_system_identity_principal_id" {
  value = module.aks_bootstrap.aks_system_identity_principal_id
}

### Identity ###
output "aks_default_user_identity_name" {
  value = var.create_user_identity ? module.aks_bootstrap.aks_default_user_identity_name : ""
}

output "aks_default_user_identity_id" {
  value = var.create_user_identity ? module.aks_bootstrap.aks_default_user_identity_id : ""
}

output "aks_default_user_identity_client_id" {
  value = var.create_user_identity ? module.aks_bootstrap.aks_default_user_identity_client_id : ""
}

output "aks_ingress_private_ip" {
  description = "Private IP to be used for the ingress controller inside the cluster"
  value       = cidrhost(cidrsubnet(var.vnet_cidr.0, 4, 0), -3)
}

output "aks_ingress_public_ip" {
  description = "Public IP to be used for the ingress controller inside the cluster"
  value       = module.aks_bootstrap.aks_ingress_public_ip
}

output "key_vault_name" {
  description = "Key Vault name, either as specified or computed if not"
  value       = module.aks_bootstrap.key_vault_name
}

output "certificate_pem" {
  description = "PEM key of certificate, can be used internally"
  value       = module.ssl_app_gateway.certificate_pem
  sensitive   = true
}

output "issuer_pem" {
  description = "PEM key of certificate, can be used internally together certificate to create a full cert"
  value       = module.ssl_app_gateway.issuer_pem
  sensitive   = true
}

output "app_gateway_ip" {
  description = "Application Gateway public IP. Should be used with DNS provider at a top level. Can have multiple subs pointing to it - e.g. app.sub.domain.com, app-uat.sub.domain.com. App Gateway will perform SSL termination for all "
  value       = module.ssl_app_gateway.app_gateway_ip
}
