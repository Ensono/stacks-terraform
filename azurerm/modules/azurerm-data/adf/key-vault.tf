resource "azurerm_key_vault" "default" {
  count = var.use_key_vault ? 1 : 0

  name                = "${var.data_factory_name}-vault"
  location            = var.region
  resource_group_name = var.resource_group_name

  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
}

resource "azurerm_role_assignment" "secrets_user_adf" {
  count = var.use_key_vault ? 1 : 0

  scope                = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.default.identity[0].principal_id
}

resource "azurerm_data_factory_linked_service_key_vault" "default" {
  count = var.use_key_vault ? 1 : 0

  name                = "ls_keyvault"
  resource_group_name = var.resource_group_name
  data_factory_id     = azurerm_data_factory.default.id
  key_vault_id        = azurerm_key_vault.default.id

  depends_on = [
    azurerm_role_assignment.secrets_user_adf
  ]
}
