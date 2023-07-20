data "azurerm_client_config" "current" {}

# data "databricks_current_user" "db" {
#   count      = var.enable_private_network ? 1 : 0
#   depends_on = [azurerm_databricks_workspace.example]
# }

data "azurerm_resource_group" "vnet_rg" {
  count = var.enable_private_network ? 1 : 0
  name  = var.vnet_resource_group
}

data "azurerm_virtual_network" "vnet" {
  count               = var.enable_private_network ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group
}

data "azurerm_subnet" "public_subnet" {
  count                = var.enable_private_network == true && var.create_subnets == false && var.managed_vnet == false ? 1 : 0
  name                 = var.public_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_subnet" "private_subnet" {
  count                = var.enable_private_network == true && var.create_subnets == false && var.managed_vnet == false ? 1 : 0
  name                 = var.private_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_subnet" "pe_subnet" {
  count = var.enable_private_network == true && var.create_pe_subnet == false && var.managed_vnet == false ? 1 : 0

  name                 = var.pe_subnet_name
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
}

data "azurerm_private_dns_zone" "adb_pvt_dns" {
  count               = var.enable_private_network ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = var.dns_resource_group_name
}
