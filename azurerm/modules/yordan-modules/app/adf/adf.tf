resource "azurerm_data_factory" "default" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
  location            = var.region
  identity {
    type = "SystemAssigned"
  }
}

