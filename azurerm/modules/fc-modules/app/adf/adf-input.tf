resource "azurerm_data_factory_linked_service_sql_server" "fcAzureSqlConnectionString" {
  name              = "fcAzureMssql_linkedService"
  data_factory_id   = azurerm_data_factory.default.id
  connection_string = "Integrated Security=False;Data Source=fc-mssqlserver.database.windows.net;Initial Catalog=fc-mssql_db;User ID=missadministrator;Password=${azurerm_key_vault_secret.fcsecret[0].value}"
}

resource "azurerm_data_factory_dataset_sql_server_table" "fcSourceDataset" {
  name                = "fcSourceDataset"
  data_factory_id     = azurerm_data_factory.default.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.fcAzureSqlConnectionString.name
  table_name          = "dbo.TestTable"
}