resource "azurerm_storage_account" "adls" {
  name                     = var.adls_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.adls_account_replication_type
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "adls" {
  for_each = var.adls_containers

  name               = each.key
  storage_account_id = azurerm_storage_account.adls.id
}
