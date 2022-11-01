output "vnet_name" {
  description = "Created VNET name.\nName can be deduced however it's better to create a direct dependency"
  value       = var.create_aksvnet ? azurerm_virtual_network.default.0.name : data.azurerm_virtual_network.default.0.name
}

output "vnet_address_space" {
  description = "Specified VNET address space"
  value       = var.create_aksvnet ? azurerm_virtual_network.default.0.address_space : data.azurerm_virtual_network.default.0.address_space
}

output "vnet_address_id" {
  description = "Specified VNET Id"
  value       = var.create_aksvnet ? azurerm_virtual_network.default.0.id : data.azurerm_virtual_network.default.0.id
}

output "resource_group_name" {
  description = "Created resource group Name"
  value       = azurerm_resource_group.default.name
  depends_on  = [azurerm_resource_group.default]
}

output "resource_group_id" {
  description = "Created resource group Id"
  value       = azurerm_resource_group.default.id
  depends_on  = [azurerm_resource_group.default]
}

output "aks_resource_group_name" {
  description = "Created AKS resource group Name"
  value       = var.create_aks ? azurerm_kubernetes_cluster.default.0.resource_group_name : ""
  depends_on  = [azurerm_resource_group.default]
}

output "aks_cluster_name" {
  description = "Created AKS resource group Name"
  value       = var.create_aks ? azurerm_kubernetes_cluster.default.0.name : ""
  depends_on  = [azurerm_resource_group.default]
}

output "acr_resource_group_name" {
  description = "Created ACR resource group Name"
  value       = var.create_acr ? azurerm_container_registry.registry.0.resource_group_name : var.acr_resource_group
  depends_on  = [azurerm_resource_group.default]
}

output "acr_registry_name" {
  description = "Created ACR name"
  value       = var.create_acr ? azurerm_container_registry.registry.0.name : var.acr_registry_name
  depends_on  = [azurerm_resource_group.default]
}

# output "aks_vmss" {
#   value = azurerm_kubernetes_cluster.default.
# }

output "aks_node_resource_group" {
  value = azurerm_kubernetes_cluster.default.0.node_resource_group
}

##########azurerm_kubernetes_cluster.default.identity.principal_id
output "aks_system_identity_principal_id" {
  value = azurerm_kubernetes_cluster.default.0.identity.0.principal_id
}

#########################################
############# Identity ##################
### used for AAD Pod identity binding ###
#########################################
output "aks_default_user_identity_name" {
  value = var.create_user_identity ? azurerm_user_assigned_identity.default.0.name : ""
}

output "aks_default_user_identity_id" {
  value = var.create_user_identity ? azurerm_user_assigned_identity.default.0.id : ""
}

output "aks_default_user_identity_client_id" {
  value = var.create_user_identity ? azurerm_user_assigned_identity.default.0.client_id : ""
}

output "aks_ingress_private_ip" {
  value = cidrhost(cidrsubnet(var.vnet_cidr.0, 4, 0), -3)
}

output "aks_ingress_public_ip" {
  value = azurerm_public_ip.external_ingress.0.ip_address
}

output "key_vault_name" {
  value = azurerm_key_vault.default.0.name
}


#########################################
# Application Insights
#########################################

output "app_insights_resource_group_name" {
  value = azurerm_log_analytics_workspace.default.resource_group_name
}
output "app_insights_name" {
  value = azurerm_log_analytics_workspace.default.name
}

output "app_insights_id" {
  value = azurerm_log_analytics_workspace.default.id
}

output "app_insights_key" {
  value = azurerm_log_analytics_workspace.default.primary_shared_key
}

#########################################
# DNS settings
#########################################

output "dns_resource_group_name" {
  value = var.dns_resource_group
}

output "dns_internal_resource_group_name" {
  value = var.dns_resource_group
}

output "dns_base_domain" {
  value = var.dns_zone
}

output "dns_base_domain_internal" {
  value = var.internal_dns_zone
}
