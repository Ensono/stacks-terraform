resource "azurerm_data_factory_linked_service_azure_blob_storage" "default" {
  name                 = "ls_blob"
  data_factory_id      = azurerm_data_factory.default.id
  service_endpoint     = var.default_storage_account_primary_blob_endpoint
  use_managed_identity = true
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls_datalake" {
  name                 = "ls_adls_datalake"
  data_factory_id      = azurerm_data_factory.default.id
  url                  = var.adls_storage_account_primary_dfs_endpoint
  use_managed_identity = true
}
