
resource "azurerm_databricks_workspace" "example" {
  name                                  = var.resource_namer
  location                              = var.resource_group_location
  resource_group_name                   = var.resource_group_name
  sku                                   = var.databricks_sku
  public_network_access_enabled         = var.enable_private_network ? false : true
  network_security_group_rules_required = var.network_security_group_rules_required

  dynamic "custom_parameters" {
    for_each = var.enable_private_network == false ? toset([]) : toset([1])
    content {
      no_public_ip                                         = true
      public_subnet_name                                   = data.azurerm_subnet.public.name
      private_subnet_name                                  = data.azurerm_subnet.private.name
      virtual_network_id                                   = data.azurerm_virtual_network.example.id
      vnet_address_prefix                                  = var.vnet_address_prefix ? var.vnet_address_prefix : null
      public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
      private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.public.id
      nat_gateway_name                                     = azurerm_nat_gateway.nat.name
      public_ip_name                                       = azurerm_public_ip.pip.name
    }
  }


  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


# Enable diagnostic settings for ADB
data "azurerm_monitor_diagnostic_categories" "adb_log_analytics_categories" {
  resource_id = azurerm_databricks_workspace.example.id
}

resource "azurerm_monitor_diagnostic_setting" "databricks_log_analytics" {
  count                      = var.enable_databricksws_diagnostic ? 1 : 0
  name                       = var.databricksws_diagnostic_setting_name
  target_resource_id         = azurerm_databricks_workspace.example.id
  log_analytics_workspace_id = var.data_platform_log_analytics_workspace_id

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

resource "databricks_workspace_conf" "this" {
  count = var.enable_enableDbfsFileBrowser ? 1 : 0
  custom_config = {

    "enableDbfsFileBrowser" : true

  }
}


resource "databricks_user" "rbac_users" {
  for_each     = var.add_rbac_users ? var.rbac_databricks_users : {}
  display_name = each.value.display_name
  user_name    = each.value.user_name
  active       = each.value.active
}

resource "databricks_group" "project_users" {
  count                 = var.add_rbac_users ? 1 : 0
  display_name          = var.databricks_group_display_name
  workspace_access      = var.enable_workspace_access
  databricks_sql_access = var.enable_sql_access
}

resource "databricks_group_member" "project_users" {
  for_each  = var.add_rbac_users ? databricks_user.rbac_users : {}
  group_id  = databricks_group.project_users[0].id
  member_id = each.value.id
}