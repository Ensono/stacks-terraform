######PROVIDER######
provider "azurerm" {
  features {}
}

#####MODULE#######

module "stacks_data" {
  source                       = "../"
  region                       = "uksouth"
  data_factory_name            = "datafactoryname"
  resource_group_name          = "resource_group_data"
  default_storage_account_name = "defaultstorageaccount"
  adls_storage_account_name    = "adlsstorageaccount"
  platform_scope               = "platformscopestacks"
}
