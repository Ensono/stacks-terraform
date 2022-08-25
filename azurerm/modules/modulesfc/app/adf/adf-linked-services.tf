resource "azurerm_role_assignment" "adls_data_owner_adf" {
  scope                = var.adls_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_data_factory.default.identity[0].principal_id
}

resource "azurerm_role_assignment" "default_data_owner_adf" {
  scope                = var.default_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_data_factory.default.identity[0].principal_id
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "default" {
  name                 = "ls_blob"
  data_factory_id      = azurerm_data_factory.default.id
  service_endpoint     = var.default_storage_account_primary_blob_endpoint
  use_managed_identity = true

  depends_on = [
    azurerm_role_assignment.default_data_owner_adf
  ]
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls_datalake" {
  name                 = "ls_adls_datalake"
  data_factory_id      = azurerm_data_factory.default.id
  url                  = var.adls_storage_account_primary_dfs_endpoint
  use_managed_identity = true

  depends_on = [
    azurerm_role_assignment.adls_data_owner_adf
  ]
}
