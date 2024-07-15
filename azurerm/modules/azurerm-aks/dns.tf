# DNS
# this is the base which will hold all your ingress records
# ensure you provide the NS records to the TLD owner
resource "azurerm_dns_zone" "default" {
  count               = var.create_dns_zone ? 1 : 0
  name                = var.dns_zone
  resource_group_name = azurerm_resource_group.default.name

  tags = var.tags

  depends_on = [azurerm_resource_group.default]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_dns_zone" "default" {
  count               = var.create_dns_zone ? 1 : 0
  name                = var.internal_dns_zone
  resource_group_name = azurerm_resource_group.default.name

  tags = var.tags

  depends_on = [azurerm_resource_group.default]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = var.resource_namer
  virtual_network_id    = azurerm_virtual_network.default.0.id
  resource_group_name   = local.dns_resource_group
  private_dns_zone_name = var.internal_dns_zone

  tags = var.tags

  depends_on = [
    azurerm_virtual_network.default,
    azurerm_private_dns_zone.default.0
  ]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

## Parent DNS Setup
data "azurerm_dns_zone" "parent" {
  count = var.create_dns_zone && var.dns_create_parent_zone_ns_records ? 1 : 0

  name                = var.dns_parent_zone
  resource_group_name = var.dns_parent_resource_group
}

resource "azurerm_dns_ns_record" "parent_link" {
  count = var.create_dns_zone && var.dns_create_parent_zone_ns_records ? 1 : 0

  # This replaces all stuff at the end of the passed DNS zone from the parent
  # E.g. `dns_zone` is nonprod.baz.stacks.com and `dns_parent_zone` is
  # stacks.com, then the value of the parent record needs to be `nonprod.baz`
  name                = replace(var.dns_zone, "/.${var.dns_parent_zone}$/", "")
  zone_name           = data.azurerm_dns_zone.parent.0.name
  resource_group_name = var.dns_parent_resource_group
  ttl                 = var.dns_parent_ns_ttl

  records = azurerm_dns_zone.default.0.name_servers

  tags = var.tags
}
