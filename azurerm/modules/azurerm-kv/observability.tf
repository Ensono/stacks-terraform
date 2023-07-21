data "azurerm_monitor_diagnostic_categories" "kv_log_analytics_categories" {
  count       = var.la_workspace_id != "" ? 1 : 0
  resource_id = azurerm_key_vault.example[0].id

  depends_on = [azurerm_key_vault.example]
}

resource "azurerm_monitor_diagnostic_setting" "kv_log_analytics" {
  count                          = var.la_workspace_id != "" ? 1 : 0
  name                           = "KV to Log Analytics"
  target_resource_id             = azurerm_key_vault.example[0].id
  log_analytics_workspace_id     = var.la_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.kv_log_analytics_categories[0].logs

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
    for_each = data.azurerm_monitor_diagnostic_categories.kv_log_analytics_categories[0].metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  depends_on = [data.azurerm_monitor_diagnostic_categories.kv_log_analytics_categories]
}