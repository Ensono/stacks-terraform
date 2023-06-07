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
  count               = var.enable_private_network ? 1 : 0
  depends_on          = [azurerm_private_endpoint.databricks]
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


############################################
# NAT GATEWAY
############################################


resource "azurerm_public_ip" "pip" {
  count               = var.enable_private_network ? 1 : 0
  name                = local.public_ip_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_nat_gateway" "nat" {
  count                   = var.enable_private_network ? 1 : 0
  name                    = local.nat_gatewat_name
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1", "2", "3"]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip" {
  count                = var.enable_private_network ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.pip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  count          = var.enable_private_network ? 1 : 0
  subnet_id      = data.azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}