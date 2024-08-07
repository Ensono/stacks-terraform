# Configure data to access the SPN that has been used to deploy the environment
# This will be used to set the SPN as an owner on the resource group
data "azurerm_client_config" "spn_client" {
}

# Always create and manage an RG as part of this library
resource "azurerm_resource_group" "default" {
  name     = var.resource_namer
  location = var.resource_group_location
  tags     = var.resource_group_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# Use a role assignment to set the SPN as an owner on the resource group
# This will allow the SPN to change role assignments of resources contained in the group
resource "azurerm_role_assignment" "rg_owner" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.spn_client.object_id
}

locals {
  vnet_name = var.create_aksvnet ? azurerm_virtual_network.default.0.name : data.azurerm_virtual_network.default.0.name
  vnet_id   = var.create_aksvnet ? azurerm_virtual_network.default.0.id : data.azurerm_virtual_network.default.0.id
}

data "azurerm_virtual_network" "default" {
  count               = var.create_aksvnet ? 0 : 1
  name                = var.vnet_name
  resource_group_name = var.vnet_name_resource_group
}

# NETWORK
resource "azurerm_virtual_network" "default" {
  count               = var.create_aksvnet ? 1 : 0
  name                = var.resource_namer
  resource_group_name = azurerm_resource_group.default.name
  address_space       = var.vnet_cidr
  location            = var.resource_group_location
  depends_on          = [azurerm_resource_group.default]
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_subnet" "default" {
  count               = var.create_aksvnet ? length(var.subnet_names) : 0
  name                = var.subnet_names[count.index]
  resource_group_name = azurerm_resource_group.default.name
  # this can stay referencing above as they get created or not together
  virtual_network_name = azurerm_virtual_network.default.0.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
  depends_on           = [azurerm_virtual_network.default]
}

# TODO: enable this for custom networking within the cluster
# resource "azurerm_route_table" "default" {
#   count               = var.create_aksvnet ? 1 : 0
#   name                = "example-routetable"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   route {
#     name                   = "example"
#     address_prefix         = "10.100.0.0/14"
#     next_hop_type          = "VirtualAppliance"
#     next_hop_in_ip_address = "10.10.1.1"
#   }
# }

# resource "azurerm_subnet_route_table_association" "default" {
#   count               = var.create_aksvnet ? 1 : 0
#   subnet_id      = azurerm_subnet.default.id
#   route_table_id = azurerm_route_table.default.id
# }
