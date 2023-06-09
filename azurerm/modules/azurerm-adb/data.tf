data "azurerm_client_config" "current" {}

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
  count                = var.enable_private_network == true && var.create_subnets == false ? 1 : 0
  name                 = var.public_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_subnet" "private_subnet" {
  count                = var.enable_private_network == true && var.create_subnets == false ? 1 : 0
  name                 = var.private_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_subnet" "pe_subnet" {
  count                = var.enable_private_network ? 1 : 0
  name                 = var.pe_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_databricks_workspace_private_endpoint_connection" "example" {
  count               = var.enable_private_network ? 1 : 0
  workspace_id        = azurerm_databricks_workspace.example.id
  private_endpoint_id = azurerm_private_endpoint.databricks[0].id
}