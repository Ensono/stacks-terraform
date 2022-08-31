resource "azurerm_role_assignment" "adls_data_owner_adf" {
  scope                = var.adls_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_data_factory.default.identity[0].principal_id
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "fcAzureDataLakeLinkedService" {
  name                 = "fcAzureDataLakeLinkedService"
  data_factory_id      = azurerm_data_factory.default.id
  url                  = "https://fcadls.dfs.core.windows.net/"
  use_managed_identity = true
  depends_on = [
    azurerm_role_assignment.adls_data_owner_adf
  ]
}
