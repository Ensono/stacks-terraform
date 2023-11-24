data "azurerm_public_ip" "default" {
  name                = azurerm_public_ip.app_gateway.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_public_ip.app_gateway]
}
