# Generates Random Password for Sql Server Admin
resource "random_password" "password" {
  length           = 16
  min_upper        = 2
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# SQL Server instance
resource "azurerm_mssql_server" "example" {
  name                         = substr(replace("${var.resource_namer}-sql", "-", ""), 0, 24)
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  version                      = var.sql_version
  administrator_login          = var.administrator_login
  administrator_login_password = random_password.password.result

  dynamic "azuread_administrator" {
    for_each = { for i in var.azuread_administrator : i.login_username => i }
    content {
      login_username = azuread_administrator.key
      object_id      = azuread_administrator.value.object_id
    }
  }


  tags = var.resource_tags
}

#Adding Sql Network Rules 
resource "azurerm_mssql_firewall_rule" "example_fw_rule" {
  for_each         = { for i in var.sql_fw_rules : i.name => i }
  name             = each.key
  server_id        = azurerm_mssql_server.example.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mssql_database" "example-db" {
  for_each                    = toset(var.sql_db_names)
  name                        = each.key
  server_id                   = azurerm_mssql_server.example.id
  create_mode                 = var.create_mode
  sample_name                 = var.sample_name
  collation                   = var.collation
  license_type                = var.license_type
  sku_name                    = var.sku_name
  zone_redundant              = var.zone_redundant
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  tags                        = var.resource_tags

}
