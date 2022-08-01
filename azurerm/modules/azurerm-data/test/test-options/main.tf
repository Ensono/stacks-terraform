module "app" {
  source = "../../"
  data_factory_name                             = var.data_factory_name
  adls_storage_account_name                     = var.adls_storage_account_name
  default_storage_account_name                  = var.default_storage_account_name
  key_vault_name                                = var.key_vault_name
  region                                        = var.region
  resource_group_name                           = var.resource_group_name
  platform_scope                                = var.platform_scope
}
