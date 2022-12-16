##################################################
# Redis Cache Resources
##################################################

resource "azurerm_redis_cache" "default-primary" {
  name                = var.resource_namer.redis_cache
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name
  minimum_tls_version = var.minimum_tls_version ? var.minimum_tls_version : "1.2"
  
  dynamic "identity" {
    for_each = ""
    identity_ids = [ "" ]
    type = ""

  }
  patch_schedule {
    day_of_week = ""
    start_hour_utc = ""
    maintenance_window = ""
  }
  private_static_ip_address = ""
  public_network_access_enabled = false

  redis_configuration {
    aof_backup_enabled = ""
    aof_storage_connection_string_0 = ""
    aof_storage_connection_string_1 = ""
    enable_authentication = ""
    maxfragmentationmemory_reserved = ""
    maxmemory_delta = ""
    maxmemory_policy = ""
    maxmemory_reserved = ""
    rdb_backup_enabled = ""
    rdb_backup_frequency = ""
    rdb_backup_max_snapshot_count = ""
    rdb_storage_connection_string = ""
    notify_keyspace_events = ""

  }
  replicas_per_master = ""
  replicas_per_primary = ""
  redis_version = 6
  tenant_settings = {
    "key" = "value"
  }
  shard_count = ""
  subnet_id = ""
  zones = ""
  tags = var.resource_tags
}

resource "azurerm_redis_firewall_rule" "default" {
  name                = var.resource_namer.redis_firewall_rule
  redis_cache_name    = azurerm_redis_cache.default.name
  resource_group_name = var.resource_group_name
  start_ip            = ""
  end_ip              = ""
}

resource "azurerm_redis_linked_server" "default" {
  target_redis_cache_name     = azurerm_redis_cache.default-primary.name
  resource_group_name         = azurerm_redis_cache.default-primary.resource_group_name
  linked_redis_cache_id       = azurerm_redis_cache.default-secondary.id
  linked_redis_cache_location = azurerm_redis_cache.default-secondary.location
  server_role                 = "Secondary"
}