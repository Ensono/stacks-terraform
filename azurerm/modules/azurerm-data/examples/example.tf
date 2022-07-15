######PROVIDER######
provider "azurerm" {
  features {}
}

#####MODULE#######

module "stacks_data" {
  source                                   = "../"
  region                                   = "uksouth"
  data_factory_name                        = "datafactoryname"
  resource_group_name                      = "resource_group_data"
  storage_account_name                     = "storageaccountdata"
  data_platform_log_analytics_workspace_id = "/subscriptions/89eb3321-bb9b-41d4-ba74-0388b7aaaebf/resourceGroups/adp-uks-sub-nonprod-core-infra-rg/providers/Microsoft.OperationalInsights/workspaces/adp-uks-sub-nonprod-core-infra-la"
  platform_scope                           = "platformscopestacks"
}
