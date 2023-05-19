

resource "azurerm_virtual_network_peering" "hub-spoke" {
  for_each                  = toset(local.spoke_network_names)
  name                      = "hub-to-${each.key}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = local.hub_network_name[0]
  remote_virtual_network_id = azurerm_virtual_network.example[each.key].id

}


resource "azurerm_virtual_network_peering" "spoke-hub" {
  for_each                  = toset(local.spoke_network_names)
  name                      = "${each.key}-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.example[each.key].name
  remote_virtual_network_id = azurerm_virtual_network.example["${local.hub_network_name[0]}"].id

}
