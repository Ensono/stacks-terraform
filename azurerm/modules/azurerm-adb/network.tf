############################################
# SUBNETS
############################################

resource "azurerm_subnet" "public_subnet" {
  count = var.enable_private_network == true && var.create_subnets == true && var.managed_vnet == false ? 1 : 0

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
  count = var.enable_private_network == true && var.create_subnets == true && var.managed_vnet == false ? 1 : 0

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
  count               = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  name                = "${var.resource_namer}-nsg-databricks"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# resource "azurerm_network_security_rule" "worker" {
#   count                       = var.enable_private_network && var.managed_vnet == false ? 1 : 0
#   name                        = "DatabricksWorkerToWorker"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "VirtualNetwork"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.nsg[0].name
# }

resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  subnet_id                 = var.create_subnets ? azurerm_subnet.private_subnet[0].id : data.azurerm_subnet.private_subnet[0].id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  subnet_id                 = var.create_subnets ? azurerm_subnet.public_subnet[0].id : data.azurerm_subnet.public_subnet[0].id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

############################################
# PRIVATE ENDPOINT
############################################

# resource "azurerm_private_endpoint" "databricks" {
#   count               = var.enable_private_network && var.managed_vnet == false ? 1 : 0
#   name                = "${var.resource_namer}-pe-databricks"
#   location            = var.resource_group_location
#   resource_group_name = var.resource_group_name
#   subnet_id           = data.azurerm_subnet.pe_subnet[0].id

#   private_service_connection {
#     name                           = "${var.resource_namer}-psc"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_databricks_workspace.example.id
#     subresource_names              = ["databricks_ui_api"]
#   }
# }

# resource "azurerm_private_dns_zone" "dns" {
#   count               = var.enable_private_network && var.managed_vnet == false ? 1 : 0
#   depends_on          = [azurerm_private_endpoint.databricks]
#   name                = "privatelink.azuredatabricks.net"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_private_dns_cname_record" "cname" {
#   count               = var.enable_private_network && var.managed_vnet == false ? 1 : 0
#   name                = azurerm_databricks_workspace.example.workspace_url
#   zone_name           = azurerm_private_dns_zone.dns[0].name
#   resource_group_name = var.resource_group_name
#   ttl                 = var.dns_record_ttl
#   record              = "${var.resource_namer}.azuredatabricks.net"
# }

resource "azurerm_public_ip" "pip" {
  count               = var.enable_private_network && var.managed_vnet == false ? 1 : 0
  name                = local.public_ip_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}