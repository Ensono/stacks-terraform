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

  for_each              = { for i in toset(local.containers_blob) : i.name => i }
  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage_account_default[each.value.account].name
  container_access_type = var.container_access_type
}

/*
resource "azurerm_storage_container" "storage_container_adls" {

  for_each = { for name in local.containers_adls : name => name }

  name                  = each.value
  storage_account_name  = each.key
  container_access_type = var.container_access_type
}

*/
locals {

  containers_blob = flatten([for account_name, account_details in var.storage_account_details : [for container_name in account_details.containers_name : { name = container_name, account = account_name }] if account_details.hns_enabled != true])

  # containers_blob = flatten([
  #   for account_name, account_details in var.storage_account_details : [
  #     for container_name in account_details.containers_name : container_name
  #   ]
  # if account_details.hns_enabled != true])

  containers_adls = flatten([for account_name, account_details in var.storage_account_details : [for container_name in account_details.containers_name : { name = container_name, account = account_name }] if account_details.hns_enabled == true])


}


resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  for_each           = { for i in toset(local.containers_adls) : i.name => i }
  name               = each.key
  storage_account_id = azurerm_storage_account.storage_account_default[each.value.account].id

}
