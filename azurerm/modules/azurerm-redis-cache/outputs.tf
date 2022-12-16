output "redis_cache_id" {
  description = ""
  value = azurerm_redis_cache.default.id
}

output "redis_cache_hostname" {
  description = ""
  value = azurerm_redis_cache.default.hostname
}

output "redis_cache_primary_access_key" {
  description = ""
  sensitive = true
  value = azurerm_redis_cache.default.primary_access_key
}

output "redis_cache_primary_connection_string" {
  description = ""
  value = azurerm_redis_cache.default.primary_connection_string
}

output "redis_cache_secondary_access_key" {
  description = ""
  sensitive = true
  value = azurerm_redis_cache.default.secondary_access_key
}

output "redis_cache_secondary_connection_string" {
  description = ""
  value = azurerm_redis_cache.default.secondary_connection_string
}

output "redis_cache_redis_configuration" {
  description = ""
  value = azurerm_redis_cache.default.redis_configuration
}

output "redis_firewall_rule_id" {
  description = ""
  value = azurerm_redis_firewall_rule.default.id
}

output "redis_linked_server_id" {
  description = ""
  value = azurerm_redis_linked_server.default.id
}

output "redis_linked_server_name" {
  description = ""
  value = azurerm_redis_linked_server.default.name
}