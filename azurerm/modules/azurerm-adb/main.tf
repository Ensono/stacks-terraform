
resource "azurerm_databricks_workspace" "example" {
  name                                  = var.resource_namer
  location                              = var.resource_group_location
  resource_group_name                   = var.resource_group_name
  sku                                   = var.databricks_sku
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.managed_vnet ? null : var.network_security_group_rules_required
  managed_resource_group_name           = "databricks-rg-${var.resource_group_name}"
  load_balancer_backend_address_pool_id = var.create_lb ? azurerm_lb_backend_address_pool.lb_be_pool[0].id : null

  dynamic "custom_parameters" {
    for_each = var.enable_private_network == false ? toset([]) : toset([1])
    content {
      no_public_ip                                         = true
      public_subnet_name                                   = var.managed_vnet ? null : (var.create_subnets ? azurerm_subnet.public_subnet[0].name : data.azurerm_subnet.public_subnet[0].name)
      private_subnet_name                                  = var.managed_vnet ? null : (var.create_subnets ? azurerm_subnet.private_subnet[0].name : data.azurerm_subnet.private_subnet[0].name)
      virtual_network_id                                   = var.managed_vnet ? null : data.azurerm_virtual_network.vnet[0].id
      vnet_address_prefix                                  = var.managed_vnet ? null : (var.vnet_address_prefix == "" ? null : var.vnet_address_prefix)
      public_subnet_network_security_group_association_id  = var.managed_vnet ? null : azurerm_subnet_network_security_group_association.public[0].id
      private_subnet_network_security_group_association_id = var.managed_vnet ? null : azurerm_subnet_network_security_group_association.private[0].id
      nat_gateway_name                                     = var.managed_vnet ? null : (var.create_nat ? azurerm_nat_gateway.nat[0].name : null)
      public_ip_name                                       = var.managed_vnet ? null : (var.create_nat ? azurerm_public_ip.pip[0].name : null)
    }
  }


  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  depends_on = [azurerm_subnet.public_subnet, azurerm_subnet.private_subnet, data.azurerm_subnet.public_subnet, data.azurerm_subnet.private_subnet]
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
