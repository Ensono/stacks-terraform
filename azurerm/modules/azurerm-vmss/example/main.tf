resource "azurerm_resource_group" "default" {
  name     = "azdo-build-test"
  location = var.vmss_resource_group_location
  tags     = var.tags
}

module "vmss" {
  source                       = "../../azurerm-vmss"
  vmss_name                    = "azdo-build-test"
  vmss_resource_group_name     = azurerm_resource_group.default.name
  vmss_resource_group_location = azurerm_resource_group.default.location
  vnet_name                    = "amido-stacks-nonprod-euw-core"
  vnet_resource_group          = "amido-stacks-nonprod-euw-core"
  subnet_name                  = "build-agent"
  vmss_instances               = 1
  vmss_admin_username          = "adminuser"
  vmss_disable_password_auth   = false
}
