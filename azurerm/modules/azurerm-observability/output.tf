#########################################
# Application Insights
#########################################

output "app_insights_resource_group_name" {
  value = azurerm_log_analytics_workspace.default.resource_group_name
}
output "app_insights_name" {
  value = azurerm_log_analytics_workspace.default.name
}

output "app_insights_id" {
  value = azurerm_application_insights.default.id
}

output "app_insights_key" {
  value = azurerm_log_analytics_workspace.default.primary_shared_key
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.default.id
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.default.name
}