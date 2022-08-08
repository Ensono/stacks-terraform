data "azurerm_monitor_diagnostic_categories" "adf_log_analytics_categories" {
  resource_id = azurerm_data_factory.default.id
}

data "azurerm_client_config" "current" {

}

data "azurerm_subscription" "current" {

}