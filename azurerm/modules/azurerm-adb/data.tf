data "azurerm_virtual_network" "vnet" {
  count               = var.enable_private_network ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.vnet_name_resource_group
}

data "azurerm_subnet" "public_subnet" {
  count                = var.enable_private_network ? 1 : 0
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_subnet" "private_subnet" {
  count                = var.enable_private_network ? 1 : 0
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_databricks_workspace_private_endpoint_connection" "example" {
  count               = var.enable_private_network ? 1 : 0
  workspace_id        = azurerm_databricks_workspace.example.id
  private_endpoint_id = azurerm_private_endpoint.databricks.id
}