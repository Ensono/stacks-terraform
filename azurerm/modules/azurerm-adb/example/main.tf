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

resource "azurerm_log_analytics_workspace" "la" {
  name                = module.default_label.id
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = var.la_sku
  retention_in_days   = var.la_retention
  tags                = module.default_label.tags
}

module "adb" {
  source                         = "../../azurerm-adb"
  resource_namer                 = module.default_label.id
  resource_group_name            = azurerm_resource_group.default.name
  resource_group_location        = azurerm_resource_group.default.location
  databricks_sku                 = var.databricks_sku
  resource_tags                  = module.default_label.tags
  enable_databricksws_diagnostic = var.enable_databricksws_diagnostic
  #databricksws_diagnostic_setting_name = var.databricksws_diagnostic_setting_name
  data_platform_log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id
}