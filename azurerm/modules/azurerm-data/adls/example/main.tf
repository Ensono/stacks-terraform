data "azurerm_client_config" "current" {}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace  = "${var.name_company}-${var.name_project}"
  stage      = var.stage
  name       = "${lookup(var.location_name_map, var.resource_group_location, "uksouth")}-${var.name_component}"
  attributes = var.attributes
  delimiter  = "-"
  tags       = var.tags
}

##################################################
# ResourceGroups
##################################################

resource "azurerm_resource_group" "default" {
  name     = module.default_label.id
  location = var.resource_group_location
  tags     = var.tags
}

module "adls_default_hns_enabled" {
  source                  = "../../adls"
  resource_namer          = module.default_label.id
  resource_group_name     = azurerm_resource_group.default.name
  resource_group_location = azurerm_resource_group.default.location
  storage_account_name    = substr(replace(module.default_label.id, "-", ""), 0, 24)
  account_kind            = "Storage"
  hns_enabled             = false

}

module "adls_default_hns_disabled" {
  source                  = "../../adls"
  resource_namer          = module.default_label.id
  resource_group_name     = azurerm_resource_group.default.name
  resource_group_location = azurerm_resource_group.default.location
  storage_account_name    = substr(replace(module.default_label.id, "-", ""), 0, 24)

  hns_enabled = true
}
