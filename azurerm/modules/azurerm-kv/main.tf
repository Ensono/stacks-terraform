
# Configure data to access the SPN that has been used to deploy the environment
data "azurerm_client_config" "current" {
}


resource "azurerm_key_vault" "example" {
  count                           = var.create_kv ? 1 : 0
  name                            = var.resource_namer
  location                        = var.resource_group_location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  sku_name                        = var.sku_name
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls
    content {
      default_action             = can(network_rules.value["default_action"]) ? network_rules.value["default_action"] : null
      virtual_network_subnet_ids = can(network_rules.value["virtual_network_subnet_ids"]) ? network_rules.value["virtual_network_subnet_ids"] : null
      ip_rules                   = can(network_rules.value["ip_rules"]) ? network_rules.value["ip_rules"] : null
      bypass                     = can(network_rules.value["bypass"]) ? network_rules.value["bypass"] : null
    }
  }


  dynamic "network_acls" {
    for_each = var.create_kv_networkacl == false ? toset([]) : toset([1])
    content {
      bypass                     = var.network_acls_bypass
      default_action             = var.network_acl_default_action
      ip_rules                   = var.network_acls_ip_rules
      virtual_network_subnet_ids = var.virtual_network_subnet_ids
    }


  }


  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


resource "azurerm_key_vault_access_policy" "contributors_access_policy" {
  count = length(var.contributor_object_ids)

  key_vault_id = azurerm_key_vault.example.0.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.contributor_object_ids[count.index]

  key_permissions = [
    "Get",
    "List",
    "Delete",
    "Create",
    "Update",
    "Import",
    "Backup",
    "Recover",
    "Restore"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Delete",
    "Set",
    "Backup",
    "Recover",
    "Restore"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Backup",
    "Recover",
    "Restore"
  ]

  storage_permissions = []
}

resource "azurerm_key_vault_access_policy" "reader_access_policy" {
  count = length(var.reader_object_ids)

  key_vault_id = azurerm_key_vault.example.0.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.reader_object_ids[count.index]

  key_permissions = [
    "Get",
    "List"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "GetIssuers",
    "List",
    "ListIssuers"
  ]
}
