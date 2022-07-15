# // Storage Account (ADLS) //
resource "azurerm_role_assignment" "adls_data_owner_adf" {
  scope                = var.adls_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_data_factory.default.identity[0].principal_id
}

# // Storage Account (Configuration) //
resource "azurerm_role_assignment" "default_data_owner_adf" {
  scope                = var.default_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_data_factory.default.identity[0].principal_id
}
