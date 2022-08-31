resource "azurerm_data_factory_dataset_delimited_text" "yordanDestinationDataset" {
  name                = "yordanDestinationDataset"
  data_factory_id     = azurerm_data_factory.default.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.yordanAzureDataLakeLinkedService.name

  parameters = {
    directory = "/",
    filename  = "yordanFileName.txt"
  }

  azure_blob_storage_location {
    container                = "raw"
    path                     = "@dataset().directory"
    filename                 = "@dataset().filename"
    dynamic_path_enabled     = true
    dynamic_filename_enabled = true
  }

  column_delimiter    = ","
  encoding            = "UTF-8"
  quote_character     = "\""
  escape_character    =  "\\"
  first_row_as_header = true
  null_value          = "NULL"
}
