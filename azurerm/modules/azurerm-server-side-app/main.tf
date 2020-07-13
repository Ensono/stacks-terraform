resource "azurerm_resource_group" "default" {
  name     = var.resource_namer
  location = var.resource_group_location
  tags     = var.resource_tags
}

####
# app level DNS can/should be controlled from here
# an alternative way of managing this would be through K8s operators
####
resource "azurerm_dns_a_record" "default" {
  count               = var.create_dns_record && !var.create_cdn_endpoint ? 1 : 0
  name                = var.dns_record
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = var.dns_ttl
  records             = var.dns_a_records
  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

module "cosmosdb" {
  # source                               = "git::https://github.com/amido/stacks-terraform//azurerm/modules/azurerm-cosmosdb?ref=v1.1.0"
  source                               = "../azurerm-cosmosdb"
  create_cosmosdb                      = var.create_cosmosdb
  resource_namer                       = var.resource_namer
  resource_tags                        = var.resource_tags
  resource_group_name                  = azurerm_resource_group.default.name
  resource_group_location              = var.resource_group_location
  cosmosdb_sql_container               = var.cosmosdb_sql_container
  cosmosdb_sql_container_partition_key = var.cosmosdb_sql_container_partition_key
  cosmosdb_kind                        = var.cosmosdb_kind
  cosmosdb_offer_type                  = var.cosmosdb_offer_type
}

resource "azurerm_redis_cache" "default" {
  count               = var.create_cache ? 1 : 0
  name                = var.resource_namer
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.default.name
  capacity            = var.cache_capacity
  family              = var.cache_family
  sku_name            = var.cache_sku_name
  enable_non_ssl_port = var.cach_enable_non_ssl_port
  minimum_tls_version = var.cache_minimum_tls_version
  redis_configuration {
    enable_authentication = var.cache_redis_enable_authentication
    maxmemory_reserved = var.cache_redis_maxmemory_reserved
    maxmemory_delta    = var.cache_redis_maxmemory_delta
    maxmemory_policy   = var.cache_redis_maxmemory_policy
  }
  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
