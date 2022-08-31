resource "azurerm_data_factory_pipeline" "fcpipeline" {
  name            = "yordanpipeline"
  data_factory_id = azurerm_data_factory.default.id
  activities_json     = file("${path.module}/yordanpipeline.json")

  parameters = {
    windowStart  = "2022-08-01",
    windowEnd    = "2022-08-31",
    "testConfig" = "false"
  }

  variables = {
    pipelineName = "yordanpipeline",
    errorFlag    = "",
    adfName      = azurerm_data_factory.default.name
  }

  depends_on = [
    azurerm_data_factory.default,
    azurerm_data_factory_dataset_sql_server_table.fcSourceDataset,
    azurerm_data_factory_dataset_delimited_text.fcDestinationDataset,
    azurerm_data_factory_linked_service_sql_server.fcAzureSqlConnectionString,
    azurerm_data_factory_linked_service_data_lake_storage_gen2.fcAzureDataLakeLinkedService
  ]
}


