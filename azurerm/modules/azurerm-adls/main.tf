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
