
resource "azurerm_virtual_network" "example" {

  for_each            = { for i in var.network_details : i.name => i if var.enable_private_networks == true }
  name                = each.key
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
  tags                = var.tags

}


resource "azurerm_subnet" "example" {

  for_each                                      = { for i in toset(local.subnets) : i.sub_name => i if var.enable_private_networks == true }
  name                                          = each.key
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = each.value.vnet
  address_prefixes                              = each.value.sub_address_prefix
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  depends_on = [
    azurerm_virtual_network.example
  ]
}
