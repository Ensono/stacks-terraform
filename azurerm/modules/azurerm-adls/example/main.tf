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

module "adls_default" {
  source                       = "../../azurerm-adls"
  resource_namer               = module.default_label.id
  resource_group_name          = azurerm_resource_group.default.name
  resource_group_location      = azurerm_resource_group.default.location
  storage_account_details      = var.storage_account_details
  container_access_type        = var.container_access_type
  resource_tags                = module.default_label.tags
  enable_private_network       = true
  pe_subnet_id                 = data.azurerm_subnet.pe_subnet.id
  pe_resource_group_name       = data.azurerm_subnet.pe_subnet.resource_group_name
  pe_resource_group_location   = "uksouth"
  dfs_dns_resource_group_name  = "hub-rg"
  blob_dns_resource_group_name = "hub-rg"

}
