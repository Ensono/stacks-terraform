data "azurerm_monitor_diagnostic_categories" "adf_log_analytics_categories" {
  count       = var.la_workspace_id != "" ? 1 : 0
  resource_id = azurerm_data_factory.example[0].id

  depends_on = [azurerm_data_factory.example]
}

resource "azurerm_monitor_diagnostic_setting" "adf_log_analytics" {
  count                          = var.la_workspace_id != "" ? 1 : 0
  name                           = "ADF to Log Analytics"
  target_resource_id             = azurerm_data_factory.example[0].id
  log_analytics_workspace_id     = var.la_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.adf_log_analytics_categories[0].logs

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
    for_each = data.azurerm_monitor_diagnostic_categories.adf_log_analytics_categories[0].metrics

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
  depends_on = [data.azurerm_monitor_diagnostic_categories.adf_log_analytics_categories]
}