
module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.16.0"
  namespace  = "${var.name_company}-${var.name_project}"
  stage      = var.stage
  name       = "${lookup(var.location_name_map, var.resource_group_location, "uksouth")}-${var.name_domain}"
  attributes = var.attributes
  delimiter  = "-"
  tags       = var.tags
}

resource "azurerm_resource_group" "default" {
  name     = module.default_label.id
  location = var.resource_group_location
  tags     = var.tags
}

module "vmss" {
  source                       = "../../azurerm-vmss"
  vmss_name                    = module.default_label.id
  vmss_resource_group_name     = azurerm_resource_group.default.name
  vmss_resource_group_location = azurerm_resource_group.default.location
  vnet_name                    = "amido-stacks-nonprod-euw-core"
  vnet_resource_group          = "amido-stacks-nonprod-euw-core"
  subnet_name                  = "build-agent"
  vmss_instances               = 1
  vmss_admin_username          = "adminuser"
  vmss_disable_password_auth   = true
}
