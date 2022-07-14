resource "azurerm_data_factory_linked_service_azure_blob_storage" "default" {
  name                 = "ls_blob"
  data_factory_id      = azurerm_data_factory.default.id
  service_endpoint     = azurerm_storage_account.default.primary_blob_endpoint
  use_managed_identity = true
  depends_on = [
    azurerm_role_assignment.default_data_owner_adf
  ]
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls_datalake" {
  name                 = "ls_adls_datalake"
  data_factory_id      = azurerm_data_factory.default.id
  url                  = azurerm_storage_account.adls.primary_dfs_endpoint
  use_managed_identity = true

  depends_on = [
    azurerm_role_assignment.adls_data_owner_adf
  ]
}
