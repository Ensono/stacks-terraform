##################################################
##  AKS SPN
##################################################
# KEY VAULT
resource "azurerm_key_vault" "default" {
  count                       = var.create_key_vault ? 1 : 0
  name                        = var.key_vault_name != "" ? var.key_vault_name : substr(var.resource_namer, 0, 24)
  location                    = var.resource_group_location
  resource_group_name         = azurerm_resource_group.default.name
  enabled_for_disk_encryption = true
  # current RG owner tenant ID
  tenant_id = var.tenant_id
  # soft_delete_enabled         = true
  # purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.spn_object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]

    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  depends_on = [
    azurerm_resource_group.default
  ]
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_user_assigned_identity" "default" {
  count               = var.create_user_identity ? 1 : 0
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.default.name
  name                = var.resource_namer
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
