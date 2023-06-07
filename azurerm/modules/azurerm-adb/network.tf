############################################
# NSG
############################################

resource "azurerm_network_security_group" "nsg" {
  count               = var.enable_private_network ? 1 : 0
  name                = "${var.prefix}-nsg-databricks"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.enable_private_network ? 1 : 0
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = var.enable_private_network ? 1 : 0
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

############################################
# PRIVATE ENDPOINT
############################################

resource "azurerm_private_endpoint" "databricks" {
  count               = var.enable_private_network ? 1 : 0
  name                = "${var.prefix}-pe-databricks"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = "${var.prefix}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.example.id
    subresource_names              = ["databricks_ui_api"]
  }
}

resource "azurerm_private_dns_zone" "dns" {
  count      = var.enable_private_network ? 1 : 0
  depends_on = [azurerm_private_endpoint.databricks]
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_cname_record" "cname" {
  count               = var.enable_private_network ? 1 : 0
  name                = azurerm_databricks_workspace.example.workspace_url
  zone_name           = azurerm_private_dns_zone.example.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = "eastus1-c2.azuredatabricks.net"
}