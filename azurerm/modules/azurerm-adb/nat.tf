############################################
# NAT GATEWAY
############################################

resource "azurerm_nat_gateway" "nat" {
  count                   = var.enable_private_network && var.create_nat && var.managed_vnet == false ? 1 : 0
  name                    = local.nat_gateway_name
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.nat_idle_timeout
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip" {
  count                = var.enable_private_network && var.create_nat && var.managed_vnet == false ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.nat[0].id
  public_ip_address_id = azurerm_public_ip.pip[0].id
}

resource "azurerm_subnet_nat_gateway_association" "public_subnet_nat" {
  count          = var.enable_private_network && var.create_nat && var.managed_vnet == false ? 1 : 0
  subnet_id      = var.create_subnets ? azurerm_subnet.public_subnet[0].id : var.public_subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private_subnet_nat" {
  count          = var.enable_private_network && var.create_nat && var.managed_vnet == false ? 1 : 0
  subnet_id      = var.create_subnets ? azurerm_subnet.private_subnet[0].id : var.private_subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat[0].id
}
