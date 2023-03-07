resource "azurerm_storage_account" "adls_default" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_kind             = var.adls_account_kind
  account_tier             = var.adls_account_tier
  account_replication_type = var.adls_account_replication_type
  is_hns_enabled           = var.adls_hns_enabled
}

resource "azurerm_storage_data_lake_gen2_filesystem" "adls_lake_default" {
  for_each = var.adls_containers

  name               = each.key
  storage_account_id = azurerm_storage_account.adls_default.id
}

resource "azurerm_storage_account" "additional_storage_account" {
  count                    = var.create_additional_storage ? 1 : 0
  name                     = "${var.storage_account_name}blob"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = var.additional_account_tier
  account_replication_type = var.additional_account_replication_type

}

resource "azurerm_storage_container" "additional_storage_container" {
  count                = var.create_additional_container ? 1 : 0
  name                 = var.resource_namer
  storage_account_name = azurerm_storage_account.additional_storage_account[0].name
}

resource "azurerm_storage_blob" "additional_storage_blob" {
  count                  = var.create_additional_blob ? 1 : 0
  name                   = var.resource_namer
  storage_account_name   = azurerm_storage_account.additional_storage_account[0].name
  storage_container_name = azurerm_storage_container.additional_storage_container[0].name
  type                   = var.blob_type
}
