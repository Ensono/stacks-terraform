data "azurerm_private_dns_zone" "blob_pvt_dns" {
  count               = var.enable_private_network ? 1 : 0
  name                = var.blob_private_dns_zone_name
  resource_group_name = var.blob_dns_resource_group_name
}

data "azurerm_private_dns_zone" "dfs_pvt_dns" {
  count               = var.enable_private_network ? 1 : 0
  name                = var.dfs_private_dns_zone_name
  resource_group_name = var.dfs_dns_resource_group_name
}
