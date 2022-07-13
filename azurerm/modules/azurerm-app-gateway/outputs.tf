data "azurerm_public_ip" "default" {
  name                = azurerm_public_ip.app_gateway.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_public_ip.app_gateway]
}

output "app_gateway_resource_group_name" {
  description = "Resource group of the application gateway"
  value       = azurerm_public_ip.app_gateway.resource_group_name
}

output "app_gateway_name" {
  description = "Name of the application gateway"
  value       = azurerm_public_ip.app_gateway.name
}

output "app_gateway_ip" {
  description = "Application Gateway public IP. Should be used with DNS provider at a top level. Can have multiple subs pointing to it - e.g. app.sub.domain.com, app-uat.sub.domain.com. App Gateway will perform SSL termination for all "
  value       = data.azurerm_public_ip.default.ip_address
}

output "certificate_pem" {
  description = "PEM key of certificate, can be used internally"
  value       = acme_certificate.default.certificate_pem
  sensitive   = true
}

output "issuer_pem" {
  description = "PEM key of certificate, can be used internally together certificate to create a full cert"
  value       = acme_certificate.default.issuer_pem
  sensitive   = true
}
