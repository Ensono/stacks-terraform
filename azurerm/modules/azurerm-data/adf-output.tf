resource "azurerm_data_factory_dataset_parquet" "ds_output_adls_datalake_raw" {
  name                = "ds_output_adls_datalake_raw"
  data_factory_id      = azurerm_data_factory.default.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls_datalake.name
  compression_codec   = "snappy"

  parameters = {
    directory = "",
    filename  = ""
  }

  azure_blob_storage_location {
    container                = "raw"
    path                     = "@dataset().directory"
    filename                 = "@dataset().filename"
    dynamic_path_enabled     = true
    dynamic_filename_enabled = true
  }
}

resource "azurerm_data_factory_dataset_parquet" "ds_output_adls_datalake_raw_file" {
  name                = "ds_output_adls_datalake_raw_file"
  data_factory_id      = azurerm_data_factory.default.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls_datalake.name
  compression_codec   = "snappy"

  parameters = {
    directory = "",
  }

  azure_blob_storage_location {
    container            = "raw"
    path                 = "@dataset().directory"
    dynamic_path_enabled = true
  }
}
