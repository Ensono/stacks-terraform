resource "azurerm_storage_account" "storage_account_default" {
  for_each = var.storage_account_details

  name                     = "${substr(replace(var.storage_account_name, "-", ""), 0, 12)}${each.value.name}"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_kind             = each.value.account_kind
  account_tier             = each.value.account_tier
  account_replication_type = var.account_replication_type
  is_hns_enabled           = each.value.hns_enabled
}


resource "azurerm_storage_container" "storage_container_blob" {
  for_each              = toset(var.container_blob)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage_account_default["blob"].name
  container_access_type = var.container_access_type
}

resource "azurerm_storage_container" "storage_container_adls" {
  for_each              = toset(var.container_adls)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage_account_default["adls"].name
  container_access_type = var.container_access_type
}
