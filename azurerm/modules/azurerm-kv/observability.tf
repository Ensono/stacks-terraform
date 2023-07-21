data "azurerm_monitor_diagnostic_categories" "kv_log_analytics_categories" {
  count       = var.la_workspace_id == "" ? 0 : 1
  resource_id = azurerm_key_vault.example.id
}

resource "azurerm_monitor_diagnostic_setting" "kv_log_analytics" {
  count                          = var.la_workspace_id == "" ? 0 : 1
  name                           = "KV to Log Analytics"
  target_resource_id             = azurerm_key_vault.example.id
  log_analytics_workspace_id     = var.la_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.kv_log_analytics_categories.logs

    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.kv_log_analytics_categories.metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
}