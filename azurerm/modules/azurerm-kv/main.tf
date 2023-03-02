
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


  dynamic "access_policy" {
    for_each = var.enable_rbac_authorization == true ? toset([]) : toset([1])
    content {

      tenant_id           = data.azurerm_client_config.current.tenant_id
      object_id           = data.azurerm_client_config.current.object_id
      key_permissions     = var.key_permissions
      secret_permissions  = var.secret_permissions
      storage_permissions = var.storage_permissions
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