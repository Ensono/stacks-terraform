# Generates Random Password for Sql Server Admin
resource "random_password" "password" {
  length           = 16
  min_upper        = 2
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# SQL Server instance
resource "azurerm_mssql_server" "example" {
  name                          = substr(replace("${var.resource_namer}-sql", "-", ""), 0, 63)
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  version                       = var.sql_version
  administrator_login           = var.administrator_login
  administrator_login_password  = random_password.password.result
  public_network_access_enabled = var.public_network_access_enabled

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
  for_each         = { for i in var.sql_fw_rules : i.name => i if var.public_network_access_enabled == true }
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

resource "azurerm_private_endpoint" "pe" {
  count               = var.enable_private_network ? 1 : 0
  name                = "${azurerm_mssql_server.example.name}-sql-pe"
  resource_group_name = var.pe_resource_group_name
  location            = var.pe_resource_group_location
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${azurerm_mssql_server.example.name}-sql-pe"
    is_manual_connection           = var.is_manual_connection
    private_connection_resource_id = azurerm_mssql_server.example.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = azurerm_mssql_server.example.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.sql_pvt_dns[0].id]
  }
}
