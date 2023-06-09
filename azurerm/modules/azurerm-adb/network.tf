############################################
# SUBNETS
############################################

resource "azurerm_subnet" "public_subnet" {
  count = var.enable_private_network == true && var.create_subnets == true ? 1 : 0

  name                 = var.public_subnet_name
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.public_subnet_prefix
  service_endpoints    = var.service_endpoints

  delegation {
    name = "${var.public_subnet_name}-databricks-del"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "private_subnet" {
  count = var.enable_private_network == true && var.create_subnets == true ? 1 : 0

  name                 = var.private_subnet_name
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.private_subnet_prefix
  service_endpoints    = var.service_endpoints

  delegation {
    name = "${var.private_subnet_name}-databricks-del"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

############################################
# NSG
############################################

resource "azurerm_network_security_group" "nsg" {
  count               = var.enable_private_network ? 1 : 0
  name                = "${var.resource_namer}-nsg-databricks"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.enable_private_network ? 1 : 0
  subnet_id                 = var.create_subnets ? azurerm_subnet.private_subnet[0].id : data.azurerm_subnet.private_subnet[0].id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = var.enable_private_network ? 1 : 0
  subnet_id                 = var.create_subnets ? azurerm_subnet.public_subnet[0].id : data.azurerm_subnet.public_subnet[0].id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

############################################
# PRIVATE ENDPOINT
############################################

resource "azurerm_private_endpoint" "databricks" {
  count               = var.enable_private_network ? 1 : 0
  name                = "${var.resource_namer}-pe-databricks"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet[0].id

  private_service_connection {
    name                           = "${var.resource_namer}-psc"
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
  zone_name           = azurerm_private_dns_zone.dns[0].name
  resource_group_name = var.resource_group_name
  ttl                 = var.dns_record_ttl
  record              = "${var.resource_namer}.azuredatabricks.net"
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
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat" {
  count                   = var.enable_private_network ? 1 : 0
  name                    = local.nat_gatewat_name
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.nat_idle_timeout
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip" {
  count                = var.enable_private_network ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.nat[0].id
  public_ip_address_id = azurerm_public_ip.pip[0].id
}

resource "azurerm_subnet_nat_gateway_association" "public_subnet_nat" {
  count          = var.enable_private_network ? 1 : 0
  subnet_id      = var.create_subnets ? azurerm_subnet.public_subnet[0].id : data.azurerm_subnet.public_subnet[0].id
  nat_gateway_id = azurerm_nat_gateway.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private_subnet_nat" {
  count          = var.enable_private_network ? 1 : 0
  subnet_id      = var.create_subnets ? azurerm_subnet.private_subnet[0].id : data.azurerm_subnet.private_subnet[0].id
  nat_gateway_id = azurerm_nat_gateway.nat[0].id
}

############################################
# ROUTE TABLES
############################################

resource "azurerm_route_table" "adb-route-table" {
  count               = var.enable_private_network ? 1 : 0
  name                = var.resource_namer
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  route {
    name                   = "to-nat"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.pip[0].id
  }

  route {
    name           = "to-scc-relay"
    address_prefix = azurerm_public_ip.pip[0].id
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "adb-pubic-rt-assocation" {
  count          = var.enable_private_network ? 1 : 0
  subnet_id      = var.create_subnets ? azurerm_subnet.public_subnet[0].id : data.azurerm_subnet.public_subnet[0].id
  route_table_id = azurerm_route_table.adb-route-table[0].id
}

resource "azurerm_subnet_route_table_association" "adb-private-rt-assocation" {
  count          = var.enable_private_network ? 1 : 0
  subnet_id      = var.create_subnets ? azurerm_subnet.private_subnet[0].id : data.azurerm_subnet.private_subnet[0].id
  route_table_id = azurerm_route_table.adb-route-table[0].id
}