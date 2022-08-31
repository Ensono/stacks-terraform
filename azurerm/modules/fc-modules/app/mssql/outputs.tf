# output "resource_group_id" {
#   value = azurerm_resource_group.rg.id
# }

# output "azurerm_virtual_network_name" {
#   value = azurerm_virtual_network.vnet.name
# }

output "azurerm_mssql_server_fcsql_server_name" {
  value = azurerm_mssql_server.fcsql-server.name
}

output "azurerm_mssql_db_fcsql_db_name" {
  value = azurerm_mssql_database.fcsql-db.name
}
