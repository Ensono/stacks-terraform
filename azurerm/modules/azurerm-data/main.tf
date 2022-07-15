resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.region
}

module "adls" {
  source = "./adls"

  adls_storage_account_name    = var.adls_storage_account_name
  default_storage_account_name = var.default_storage_account_name
  platform_scope               = var.platform_scope
  region                       = var.region
  resource_group_name          = azurerm_resource_group.default.name
}

module "adf" {
  source = "./adf"

  data_factory_name                             = var.data_factory_name
  data_platform_log_analytics_workspace_id      = var.data_platform_log_analytics_workspace_id
  platform_scope                                = var.platform_scope
  region                                        = var.region
  resource_group_name                           = azurerm_resource_group.default.name
  adls_storage_account_id                       = module.adls.adls_storage_account_id
  default_storage_account_id                    = module.adls.default_storage_account_id
  adls_storage_account_primary_dfs_endpoint     = module.adls.adls_storage_account_primary_dfs_endpoint
  default_storage_account_primary_blob_endpoint = module.adls.default_storage_account_primary_blob_endpoint
}