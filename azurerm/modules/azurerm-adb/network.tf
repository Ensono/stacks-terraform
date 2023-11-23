############################################
# SUBNETS
############################################

resource "azurerm_subnet" "public_subnet" {
  count = var.enable_private_network == true && var.create_subnets == true && var.managed_vnet == false ? 1 : 0

  name                 = var.public_subnet_name
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.public_subnet_prefix

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "private_subnet" {
  count = var.enable_private_network == true && var.create_subnets == true && var.managed_vnet == false ? 1 : 0

  name                 = var.private_subnet_name
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.private_subnet_prefix

  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }

  service_endpoints = var.service_endpoints
}

resource "azurerm_subnet" "pe_subnet" {
  count = var.enable_private_network == true && var.create_pe_subnet == true && var.managed_vnet == false ? 1 : 0

  name                                           = var.pe_subnet_name
  resource_group_name                            = var.vnet_resource_group
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = var.pe_subnet_prefix
  enforce_private_link_endpoint_network_policies = true
}


############################################
# NSG
############################################

resource "azurerm_network_security_group" "nsg" {
  count               = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  name                = "${var.resource_namer}-nsg-databricks"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_network_security_rule" "nsg_rule" {
  count                       = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  name                        = "adf-db-inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "DataFactory.WestEurope"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_network_security_rule" "aad" {
  count                       = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  name                        = "AllowAAD"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureActiveDirectory"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_network_security_rule" "azfrontdoor" {
  count                       = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  name                        = "AllowAzureFrontDoor"
  priority                    = 201
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureFrontDoor.Frontend"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}


resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  subnet_id                 = var.create_subnets ? azurerm_subnet.private_subnet[0].id : var.private_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  subnet_id                 = var.create_subnets ? azurerm_subnet.public_subnet[0].id : var.public_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

############################################
# PRIVATE ENDPOINT
############################################

resource "azurerm_private_endpoint" "databricks" {
  count = var.enable_private_network && var.managed_vnet == false ? 1 : 0

  name                = "${var.resource_namer}-pe-databricks"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.create_pe_subnet ? azurerm_subnet.pe_subnet[0].id : var.pe_subnet_id

  private_service_connection {
    name                           = "${var.resource_namer}-db-pe"
    private_connection_resource_id = azurerm_databricks_workspace.example.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {

    name                 = "databricks_ui_api"
    private_dns_zone_ids = ["${var.private_dns_zone_id}"]
  }

  depends_on = [azurerm_databricks_workspace.example]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "auth" {
  count               = var.enable_private_network && var.managed_vnet == false && var.browser_authentication_enabled == true ? 1 : 0
  name                = "${var.resource_namer}-pe-databricks-auth"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.create_pe_subnet ? azurerm_subnet.pe_subnet[0].id : var.pe_subnet_id

  private_service_connection {
    name                           = "${var.resource_namer}-db-pe-auth"
    private_connection_resource_id = azurerm_databricks_workspace.example.id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

  private_dns_zone_group {
    name                 = "databricks_auth"
    private_dns_zone_ids = ["${var.private_dns_zone_id}"]
  }

  depends_on = [azurerm_databricks_workspace.example]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}
/*
resource "azurerm_private_dns_zone" "dns" {
  count               = var.enable_private_network && var.managed_vnet == false && var.create_db_dns_zone ? 1 : 0
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.resource_group_name
}

data "azurerm_private_dns_zone" "dns" {
  count               = var.create_db_dns_zone == false ? 1 : 0
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.db_dns_zone_rg
}

resource "azurerm_private_dns_cname_record" "cname" {
  count               = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  name                = azurerm_databricks_workspace.example.workspace_url
  zone_name           = var.create_db_dns_zone ? azurerm_private_dns_zone.dns[0].name : data.azurerm_private_dns_zone.dns[0].name
  resource_group_name = var.create_db_dns_zone ? var.resource_group_name : var.db_dns_zone_rg
  ttl                 = var.dns_record_ttl
  record              = "${var.resource_namer}.azuredatabricks.net"
}

resource "azurerm_private_dns_zone_virtual_network_link" "db_dns_vnet_link" {
  count                 = var.enable_private_network == true && var.managed_vnet == false && var.create_db_dns_zone == true ? 1 : 0
  name                  = var.resource_namer
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns[0].name
  virtual_network_id    = data.azurerm_virtual_network.vnet[0].id
}
*/
resource "azurerm_public_ip" "pip" {
  count               = var.enable_private_network && var.create_pip && var.managed_vnet == false ? 1 : 0
  name                = local.public_ip_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}
