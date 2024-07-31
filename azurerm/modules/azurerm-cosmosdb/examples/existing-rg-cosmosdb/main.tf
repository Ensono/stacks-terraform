data "azurerm_client_config" "current" {}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace  = "${var.name_company}-${var.name_project}"
  stage      = var.stage
  name       = "${lookup(var.location_name_map, var.resource_group_location, "westeurope")}-${var.name_component}"
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

module "cosmosdb" {
  source                               = "../../"
  create_cosmosdb                      = true
  resource_namer                       = module.default_label.id
  resource_group_name                  = azurerm_resource_group.default.name
  cosmosdb_sql_container               = "Menu"
  cosmosdb_sql_container_partition_key = "/id"
  cosmosdb_kind                        = "GlobalDocumentDB"
  cosmosdb_offer_type                  = "Standard"
}
