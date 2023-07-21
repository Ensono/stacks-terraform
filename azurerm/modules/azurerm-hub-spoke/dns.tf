resource "azurerm_private_dns_zone" "example" {
  for_each            = toset(var.dns_zone_name)
  name                = each.key
  resource_group_name = local.hub_resource_group_name[0]
  tags                = var.tags
  depends_on          = [azurerm_resource_group.network]
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub-privatelink-dns" {
  for_each              = var.link_dns_network == true ? toset(var.dns_zone_name) : toset([])
  name                  = each.key
  resource_group_name   = local.hub_resource_group_name[0]
  registration_enabled  = false # Auto registration_enabled set to false as we cannot add multiple Private DNS to 1 Vnet
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.example["${local.hub_network_name[0]}"].id
  depends_on            = [azurerm_resource_group.network, azurerm_private_dns_zone.example]
}
