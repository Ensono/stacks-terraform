locals {
  create_resource_group = var.create_cosmosdb || var.create_cache || var.create_cdn_endpoint

  # We want to create the A Record if we are trying to create DNS but not a
  # CDN, OR, If we want to create an Alias DNS and a CDN
  create_app_gateway_dns = (var.create_dns_record && !var.create_cdn_endpoint) || (var.create_dns_record && var.create_cdn_endpoint && var.dns_enable_alias_record) ? 1 : 0
}
