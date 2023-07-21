data "azurerm_client_config" "spn_client" {
}

data "azurerm_resource_group" "default" {
  name = var.resource_group_name
}
