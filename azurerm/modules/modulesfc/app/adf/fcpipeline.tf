resource "azurerm_data_factory_pipeline" "fc-pipeline" {
  name            = "fcpipeline"
  data_factory_id = azurerm_data_factory.default.id
  activities_json     = file("${path.module}/fcpipeline.json")

  parameters = {
    windowStart  = "",
    windowEnd    = "",
    "testConfig" = "false"
  }

  variables = {
    pipelineName = "fcpipeline",
    errorFlag    = "",
    adfName      = azurerm_data_factory.default.name
  }

  depends_on = [
    azurerm_data_factory.default,
    azurerm_data_factory_dataset_json.ds_input_blob_config
  ]
}


