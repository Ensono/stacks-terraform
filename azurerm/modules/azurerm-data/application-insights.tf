resource "azurerm_application_insights" "default" {
  name                = "application_insights_data"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  application_type                      = "other"
  retention_in_days                     = var.application_insights_retention_in_days
  daily_data_cap_in_gb                  = var.application_insights_daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.application_insights_daily_data_cap_notifications_disabled
}
