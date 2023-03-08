resource "azurerm_storage_account" "adls_default" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  is_hns_enabled           = var.hns_enabled
}

resource "azurerm_storage_data_lake_gen2_filesystem" "adls_lake_default" {
  for_each = { for k, v in var.adls_containers : k => v if var.hns_enabled }

  name               = each.key
  storage_account_id = azurerm_storage_account.adls_default.id
}

resource "azurerm_storage_container" "additional_storage_container" {

  count                = var.hns_enabled ? 0 : 1
  name                 = var.resource_namer
  storage_account_name = azurerm_storage_account.adls_default.name

}

