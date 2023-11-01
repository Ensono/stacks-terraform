locals {
  containers_blob      = flatten([for account_name, account_details in var.storage_account_details : [for container_name in account_details.containers_name : { name = container_name, account = account_name }] if account_details.hns_enabled != true])
  containers_adls      = flatten([for account_name, account_details in var.storage_account_details : [for container_name in account_details.containers_name : { name = container_name, account = account_name }] if account_details.hns_enabled == true])
  adls_storage_account = flatten([for account_name, account_details in var.storage_account_details : account_name if account_details.hns_enabled == true])
  blob_storage_account = flatten([for account_name, account_details in var.storage_account_details : account_name if account_details.hns_enabled != true])

}

resource "azurerm_storage_account" "storage_account_default" {
  for_each = var.storage_account_details

  name                          = substr(replace("${var.resource_namer}${each.value.name}", "-", ""), 0, 24)
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  account_kind                  = each.value.account_kind
  account_tier                  = each.value.account_tier
  account_replication_type      = var.account_replication_type
  is_hns_enabled                = each.value.hns_enabled
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_rules" {
    for_each = var.network_rules
    content {
      default_action             = can(network_rules.value["default_action"]) ? network_rules.value["default_action"] : null
      virtual_network_subnet_ids = can(network_rules.value["virtual_network_subnet_ids"]) ? network_rules.value["virtual_network_subnet_ids"] : null
      ip_rules                   = can(network_rules.value["ip_rules"]) ? network_rules.value["ip_rules"] : null
      bypass                     = can(network_rules.value["bypass"]) ? network_rules.value["bypass"] : null
    }
  }

  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "pe_dfs" {
  for_each = {
    for account_name, account_details in var.storage_account_details : account_name => account_details
    if var.enable_private_network && account_details.hns_enabled
  }
  name                = "${var.resource_namer}-storage-${each.value.name}-pe-dfs"
  resource_group_name = var.pe_resource_group_name
  location            = var.pe_resource_group_location
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${var.resource_namer}-storage-${each.value.name}-pe-dfs"
    private_connection_resource_id = azurerm_storage_account.storage_account_default[each.key].id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = ["dfs"]
  }

  private_dns_zone_group {
    name                 = azurerm_storage_account.storage_account_default[each.key].name
    private_dns_zone_ids = [var.dfs_private_zone_id]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "pe_blob" {
  for_each = {
    for account_name, account_details in var.storage_account_details : account_name => account_details
    if var.enable_private_network
  }
  name                = "${var.resource_namer}-storage-${each.value.name}-pe-blob"
  resource_group_name = var.pe_resource_group_name
  location            = var.pe_resource_group_location
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${var.resource_namer}-storage-${each.value.name}-pe-blob"
    private_connection_resource_id = azurerm_storage_account.storage_account_default[each.key].id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = azurerm_storage_account.storage_account_default[each.key].name
    private_dns_zone_ids = [var.blob_private_zone_id]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "null_resource" "sleep" {
  # Add sleep to allow network rules to propergate
  provisioner "local-exec" {
    command = <<EOT
      sleep 60
    EOT
  }
  depends_on = [azurerm_storage_account.storage_account_default, azurerm_private_endpoint.pe_blob, azurerm_private_endpoint.pe_dfs]
}

resource "azurerm_storage_container" "storage_container_blob" {
  for_each              = { for i in toset(local.containers_blob) : i.name => i }
  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage_account_default[each.value.account].name
  container_access_type = var.container_access_type

  depends_on = [azurerm_storage_account.storage_account_default, azurerm_role_assignment.storage_role_context, null_resource.sleep]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  for_each           = { for i in toset(local.containers_adls) : i.name => i }
  name               = each.key
  storage_account_id = azurerm_storage_account.storage_account_default[each.value.account].id

  depends_on = [azurerm_storage_account.storage_account_default, azurerm_role_assignment.storage_role_context, null_resource.sleep]
}

resource "azurerm_role_assignment" "storage_role_context" {
  for_each             = var.storage_account_details
  scope                = azurerm_storage_account.storage_account_default[each.key].id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.azure_object_id
}

