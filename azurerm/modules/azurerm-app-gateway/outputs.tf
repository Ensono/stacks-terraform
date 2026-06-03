output "app_gateway_resource_group_name" {
  description = "Resource group of the application gateway"
  value       = azurerm_application_gateway.network.resource_group_name
}

output "app_gateway_name" {
  description = "Name of the application gateway"
  value       = azurerm_application_gateway.network.name
}

output "app_gateway_ip" {
  description = "Application Gateway public IP. Should be used with DNS provider at a top level. Can have multiple subs pointing to it - e.g. app.sub.domain.com, app-uat.sub.domain.com. App Gateway will perform SSL termination for all"
  value       = data.azurerm_public_ip.default.ip_address
}

output "app_gateway_ip_name" {
  description = "Application Gateway public IP name"
  value       = azurerm_public_ip.app_gateway.name
}

output "certificate_pem" {
  description = "PEM key of certificate, can be used internally"
  value       = local.inline_certificate_pem
  sensitive   = true
}

output "issuer_pem" {
  description = "PEM key of certificate, can be used internally together certificate to create a full cert"
  value       = local.inline_issuer_pem
  sensitive   = true
}

output "effective_certificate_source" {
  description = "Effective certificate source mode used by the module after applying backward-compatible defaults."
  value       = local.effective_certificate_source
}

output "effective_key_vault_secret_id" {
  description = "Effective Key Vault secret ID used by the Application Gateway when certificate_source is key_vault."
  value       = local.use_key_vault_certificate ? var.key_vault_secret_id : null
}

output "app_gateway_identity" {
  description = "Application Gateway managed identity details used for downstream RBAC and diagnostics."
  value = local.app_gateway_identity_enabled ? {
    type                       = try(azurerm_application_gateway.network.identity[0].type, var.identity_type)
    principal_id               = try(azurerm_application_gateway.network.identity[0].principal_id, null)
    tenant_id                  = try(azurerm_application_gateway.network.identity[0].tenant_id, null)
    user_assigned_identity_ids = try(azurerm_application_gateway.network.identity[0].identity_ids, local.app_gateway_identity_ids)
  } : null
}

output "app_gateway_identity_principal_id" {
  description = "Application Gateway managed identity principal ID when an identity is configured."
  value       = try(azurerm_application_gateway.network.identity[0].principal_id, null)
}

output "app_gateway_identity_tenant_id" {
  description = "Application Gateway managed identity tenant ID when an identity is configured."
  value       = try(azurerm_application_gateway.network.identity[0].tenant_id, null)
}

output "app_gateway_identity_type" {
  description = "Application Gateway managed identity type."
  value       = try(azurerm_application_gateway.network.identity[0].type, null)
}

output "app_gateway_user_assigned_identity_ids" {
  description = "User-assigned identity resource IDs attached to the Application Gateway."
  value       = try(azurerm_application_gateway.network.identity[0].identity_ids, local.app_gateway_identity_ids)
}
