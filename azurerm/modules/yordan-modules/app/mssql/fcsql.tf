resource "azurerm_mssql_server" "yordansql-server" {
  name                         = "yordan-mssqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.region
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_mssql_database" "yordansql-db" {
  name           = "yordan-mssql_db"
  server_id      = azurerm_mssql_server.yordansql-server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    environment = "sandbox"
  }

  depends_on = [
    azurerm_mssql_server.yordansql-server
  ]
}

resource "azurerm_mssql_firewall_rule" "allow_azure" {
  count = var.mssql_server_enable ? 1 : 0
  name                = "AllowAccessFromAzureResources"
  server_id         = azurerm_mssql_server.yordansql-server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "allow_all" {
  count = var.mssql_server_enable ? 1 : 0
  name                = "AllowAll"
  server_id         = azurerm_mssql_server.yordansql-server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "null_resource" "seed_test_database" {
count = fileexists(local.sql_input_file) ? 1 : 0

  provisioner "local-exec" {

  command = <<EOF
  if (!(Get-Module -ListAvailable -Name SqlServer)) {
    Install-Module -Name SqlServer -Force
  }
  Invoke-Sqlcmd -ServerInstance ${azurerm_mssql_server.yordansql-server.name}.database.windows.net `
    -Database ${azurerm_mssql_database.yordansql-db.name} `
    -Username ${azurerm_mssql_server.yordansql-server.administrator_login} `
    -Password ${azurerm_mssql_server.yordansql-server.administrator_login_password}  `
    -InputFile ${local.sql_input_file}  `
    -Verbose
  EOF
  interpreter = ["pwsh", "-command"]
}

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [
    azurerm_mssql_server.yordansql-server,
    azurerm_mssql_database.yordansql-db,
    azurerm_mssql_firewall_rule.allow_azure,
    azurerm_mssql_firewall_rule.allow_all
  ]
}