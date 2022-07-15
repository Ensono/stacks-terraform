resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.region
}

module "adf" {
  source = "./adf"

  data_factory_name                             = var.data_factory_name
  data_platform_log_analytics_workspace_id      = var.data_platform_log_analytics_workspace_id
  platform_scope                                = var.platform_scope
  region                                        = var.region
  resource_group_name                           = azurerm_resource_group.default.name
  adls_storage_account_id                       = azurerm_storage_account.adls.id
  default_storage_account_id                    = azurerm_storage_account.default.id
  adls_storage_account_primary_dfs_endpoint     = azurerm_storage_account.adls.primary_dfs_endpoint
  default_storage_account_primary_blob_endpoint = azurerm_storage_account.default.primary_blob_endpoint
}