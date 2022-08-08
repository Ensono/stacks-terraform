resource "azurerm_data_factory" "default" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
  location            = var.region
  identity {
    type = "SystemAssigned"
  }

  dynamic "github_configuration" {
    for_each = var.github_configuration[*]
    content {
      account_name    = github_configuration.value.account_name
      branch_name     = github_configuration.value.branch_name
      git_url         = github_configuration.value.git_url
      repository_name = github_configuration.value.repository_name
      root_folder     = github_configuration.value.root_folder
    }
  }

  dynamic "vsts_configuration" {
    for_each = var.azure_devops_configuration[*]
    content {
      account_name    = vsts_configuration.value.account_name
      branch_name     = vsts_configuration.value.branch_name
      project_name    = vsts_configuration.value.project_name
      repository_name = vsts_configuration.value.repository_name
      root_folder     = vsts_configuration.value.root_folder
      tenant_id       = vsts_configuration.value.tenant_id
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "adf_log_analytics" {
  count = var.data_platform_log_analytics_workspace_id != null ? 1 : 0

  name                           = "ADF to Log Analytics"
  target_resource_id             = azurerm_data_factory.default.id
  log_analytics_workspace_id     = var.data_platform_log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.adf_log_analytics_categories.logs

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
    for_each = data.azurerm_monitor_diagnostic_categories.adf_log_analytics_categories.metrics

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
