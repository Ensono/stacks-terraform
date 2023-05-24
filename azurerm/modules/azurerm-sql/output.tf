output "sql_sa_password" {
  sensitive = true
  value     = azurerm_mssql_server.example.administrator_login_password
}

output "sql_sa_login" {
  sensitive = true
  value     = azurerm_mssql_server.example.administrator_login
}

output "sql_server_name" {
  sensitive = true
  value     = azurerm_mssql_server.example.name
}


output "sql_server_id" {
  sensitive = true
  value     = azurerm_mssql_server.example.id
}
