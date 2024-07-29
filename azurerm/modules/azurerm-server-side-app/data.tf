data "azurerm_public_ip" "ip_address" {
  count = local.create_app_gateway_dns

  name                = var.dns_ip_address_name
  resource_group_name = var.dns_ip_address_resource_group
}
