#Azure Generic vNet Module
data "azurerm_resource_group" "network" {
  count = var.existing_resource_group_name == null ? 0 : 1
  name  = var.existing_resource_group_name
}

resource "azurerm_resource_group" "network" {
  count    = var.existing_resource_group_name == null ? 1 : 0
  name     = var.resource_group_name
  location = var.resource_group_location
  #tags     = var.tags
}


module "networking" {
  source                  = "../../azurerm-hub-spoke"
  enable_private_networks = true ## NOTE setting this value to false will cause no resources to be created !!
  network_details         = var.network_details
  resource_group_name     = azurerm_resource_group.network[0].name
  resource_group_location = azurerm_resource_group.network[0].location
  create_hub_fw           = true
  create_fw_public_ip     = false
  name_az_fw              = "testfirewall"
  sku_az_fw               = "AZFW_Hub"
  sku_tier_az_fw          = "Basic"
  create_private_dns_zone = true
}
