resource "azurerm_data_factory_linked_service_sql_server" "yordanAzureSqlConnectionString" {
  name              = "yordanAzureMssql_linkedService"
  data_factory_id   = azurerm_data_factory.default.id
  connection_string = "Integrated Security=False;Data Source=yordan-mssqlserver.database.windows.net;Initial Catalog=yordan-mssql_db;User ID=missadministrator;Password=thisIsKat11"
}

resource "azurerm_data_factory_dataset_sql_server_table" "yordanSourceDataset" {
  name                = "yordanSourceDataset"
  data_factory_id     = azurerm_data_factory.default.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.yordanAzureSqlConnectionString.name
  table_name          = "dbo.TestTable"
}