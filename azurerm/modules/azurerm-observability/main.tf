#########################################
# OBSERVABILITY
#########################################

resource "azurerm_log_analytics_workspace" "default" {
  name                = var.la_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_log_analytics_solution" "default" {
  solution_name         = "ContainerInsights"
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  workspace_resource_id = azurerm_log_analytics_workspace.default.id
  workspace_name        = azurerm_log_analytics_workspace.default.name
  depends_on            = [azurerm_log_analytics_workspace.default]
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_application_insights" "default" {
  name                = var.app_insights_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  application_type    = var.log_application_type
  workspace_id        = azurerm_log_analytics_workspace.default.id
  depends_on          = [azurerm_log_analytics_workspace.default]
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
