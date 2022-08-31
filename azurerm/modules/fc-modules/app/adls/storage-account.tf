resource "azurerm_storage_account" "default" {
  name                     = var.default_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "data_platform" {
  name                 = var.platform_scope
  storage_account_name = azurerm_storage_account.default.name
}
