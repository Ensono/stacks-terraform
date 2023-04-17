data "azurerm_client_config" "current" {
}


resource "azurerm_databricks_workspace" "example" {
  name                = var.resource_namer
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.databricks_sku
  
  
  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

#locals {
#  is_diagnostic_enabled = var.enable_databricksws_diagnostic ? true : false
#}

# Enable diagnostic settings for ADB
data "azurerm_monitor_diagnostic_categories" "adb_log_analytics_categories" {
  resource_id = azurerm_databricks_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "databricks_log_analytics" {
  #count = local.is_diagnostic_enabled ? 1 : 0
  for_each = var.enable_databricksws_diagnostic ? { "enabled" = true } : {}
  name                       = var.databricksws_diagnostic_setting_name
  target_resource_id         = azurerm_databricks_workspace.example.id
  log_analytics_workspace_id = var.data_platform_log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.adb_log_analytics_categories.logs

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
    for_each = data.azurerm_monitor_diagnostic_categories.adb_log_analytics_categories.metrics

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