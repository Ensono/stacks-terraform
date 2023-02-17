output "redis_cache_id" {
  description = ""
  value = azurerm_redis_cache.default-primary.id
}

output "redis_cache_hostname" {
  description = ""
  value = azurerm_redis_cache.default-primary.hostname
}

output "redis_cache_port" {
  description = ""
  value = azurerm_redis_cache.default-primary.port
}

output "redis_cache_primary_access_key" {
  description = ""
  sensitive = true
  value = azurerm_redis_cache.default-primary.primary_access_key
}

output "redis_cache_primary_connection_string" {
  description = ""
  sensitive = true
  value = azurerm_redis_cache.default-primary.primary_connection_string
}

output "redis_cache_secondary_access_key" {
  description = ""
  sensitive = true
  value = azurerm_redis_cache.default-primary.secondary_access_key
}

output "redis_cache_secondary_connection_string" {
  description = ""
  sensitive = true
  value = azurerm_redis_cache.default-primary.secondary_connection_string
}

output "redis_cache_ssl_port" {
  description = ""
  value = azurerm_redis_cache.default-primary.ssl_port
}

output "redis_cache_redis_configuration" {
  description = ""
  value = azurerm_redis_cache.default-primary.redis_configuration
}

# output "redis_firewall_rule_id" {
#   description = ""
#   value = azurerm_redis_firewall_rule.default.id
# }

# output "redis_linked_server_id" {
#   description = ""
#   value = azurerm_redis_linked_server.default.id
# }

# output "redis_linked_server_name" {
#   description = ""
#   value = azurerm_redis_linked_server.default.name
# }