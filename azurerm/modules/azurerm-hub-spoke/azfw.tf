

resource "azurerm_subnet" "az_fw_subnet" {
  count                = var.create_hub_fw ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.network[0].name
  virtual_network_name = local.hub_network_name[0]
  address_prefixes     = var.hub_fw_address_prefixes

}

resource "azurerm_public_ip" "example" {
  count               = var.create_fw_public_ip && var.create_hub_fw ? 1 : 0
  name                = var.fw_public_ip_name
  location            = azurerm_resource_group.network[0].location
  resource_group_name = azurerm_resource_group.network[0].name
  allocation_method   = var.fw_public_allocation_method
  sku                 = var.fw_public_ip_sku
  tags                = var.tags
}

resource "azurerm_firewall" "example" {
  count               = var.create_fw_public_ip && var.create_hub_fw ? 1 : 0
  name                = var.name_az_fw
  location            = azurerm_resource_group.network[0].location
  resource_group_name = azurerm_resource_group.network[0].name
  sku_name            = var.sku_az_fw
  sku_tier            = var.sku_tier_az_fw
  tags                = var.tags

  ip_configuration {
    name                 = var.ip_config_name_az_fw
    subnet_id            = azurerm_subnet.az_fw_subnet[0].id
    public_ip_address_id = azurerm_public_ip.example[0].id
  }
}
