resource "azurerm_resource_group" "default" {
  count = local.create_resource_group ? 1 : 0

  name     = var.resource_namer
  location = var.resource_group_location

  tags = var.resource_tags
}

####
# app level DNS can/should be controlled from here
# an alternative way of managing this would be through K8s operators
####
resource "azurerm_dns_a_record" "default" {
  count = local.create_app_gateway_dns

  # If we are creating a CDN and also the Alias Record then we want to append
  # something to the record for the App Gateway to distinguish the CDN endpoint
  # e.g. dev-api.nonprod.stacks.ensono.com is the intended CDN endpoint,
  # dev-api-appgw.nonprod.stacks.ensono.com is the Alias record for the App GW
  # public IP
  name                = local.create_cdn_alias_dns ? "${var.dns_record}-appgw" : var.dns_record
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = var.dns_ttl

  # If we want to set up an alias (default true since 6.x) then point to the IP
  # resource, else point to the list of passed DNS Records
  target_resource_id = var.dns_enable_alias_record ? data.azurerm_public_ip.ip_address.0.id : null
  records            = var.dns_enable_alias_record ? null : var.dns_a_records

  tags = var.resource_tags
}

module "cosmosdb" {
  count = var.create_cosmosdb ? 1 : 0

  source = "../azurerm-cosmosdb"

  create_cosmosdb                      = true
  resource_namer                       = var.resource_namer
  resource_tags                        = var.resource_tags
  resource_group_name                  = azurerm_resource_group.default.0.name
  resource_group_location              = var.resource_group_location
  cosmosdb_sql_container               = var.cosmosdb_sql_container
  cosmosdb_sql_container_partition_key = var.cosmosdb_sql_container_partition_key
  cosmosdb_kind                        = var.cosmosdb_kind
  cosmosdb_offer_type                  = var.cosmosdb_offer_type
}

resource "azurerm_redis_cache" "default" {
  count = var.create_cache ? 1 : 0

  name                = var.resource_namer
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.default.0.name
  capacity            = var.cache_capacity
  family              = var.cache_family
  sku_name            = var.cache_sku_name
  non_ssl_port_enabled  = var.cach_enable_non_ssl_port
  minimum_tls_version = var.cache_minimum_tls_version

  redis_configuration {
    authentication_enabled = var.cache_redis_enable_authentication
    maxmemory_reserved    = var.cache_redis_maxmemory_reserved
    maxmemory_delta       = var.cache_redis_maxmemory_delta
    maxmemory_policy      = var.cache_redis_maxmemory_policy
  }

  tags = var.resource_tags
}
