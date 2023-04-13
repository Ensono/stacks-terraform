output "sql_sq_password" {
  sensitive = true
  value     = azurerm_mssql_server.example.administrator_login_password
}
