data "azurerm_monitor_diagnostic_categories" "adls_log_analytics_categories" {
  for_each    = var.storage_account_details && var.la_workspace_id != ""
  resource_id = azurerm_storage_account.storage_account_default["${each.value.name}"].id
}

resource "azurerm_monitor_diagnostic_setting" "adls_log_analytics" {
  for_each                       = var.storage_account_details && var.la_workspace_id != ""
  name                           = "Storage to Log Analytics"
  target_resource_id             = azurerm_storage_account.storage_account_default["${each.value.name}"].id
  log_analytics_workspace_id     = var.la_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.adls_log_analytics_categories.logs

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
    for_each = data.azurerm_monitor_diagnostic_categories.adls_log_analytics_categories.metrics

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