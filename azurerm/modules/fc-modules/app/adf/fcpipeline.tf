resource "azurerm_data_factory_pipeline" "fcpipeline" {
  name            = "fcpipeline"
  data_factory_id = azurerm_data_factory.default.id
  activities_json     = file("${path.module}/fcpipelinecopy.json")

  parameters = {
    windowStart  = "2022-08-01",
    windowEnd    = "2023-08-31",
    "testConfig" = "false"
  }

  variables = {
    pipelineName = "fcpipeline",
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

resource "azurerm_data_factory_trigger_schedule" "fcPipelineTrigger" {
  name            = "fcPipelineTrigger"
  data_factory_id = azurerm_data_factory.default.id
  pipeline_name   = azurerm_data_factory_pipeline.fcpipeline.name

  interval  = 5
  frequency = "Minute"
}




