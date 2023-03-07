resource "azurerm_storage_account" "adls_default" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.adls_account_replication_type
  is_hns_enabled           = var.hns_enabled
}

resource "azurerm_storage_data_lake_gen2_filesystem" "adls_lake_default" {
  for_each = var.adls_containers

  name               = each.key
  storage_account_id = azurerm_storage_account.adls_default.id
}

resource "azurerm_storage_container" "adls_container" {
  name                 = var.resource_namer
  storage_account_name = azurerm_storage_account.adls_default.name
}

resource "azurerm_storage_blob" "adls_blob" {
  name                   = var.resource_namer
  storage_account_name   = azurerm_storage_account.adls_default.name
  storage_container_name = azurerm_storage_container.adls_container.name
  type                   = var.blob_type
}