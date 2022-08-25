output "ADF_ACCOUNT_NAME" {
  description = "Azure Data Factory Name"
  value       = azurerm_data_factory.default.name
}

output "ADF_FACTORY_ID" {
  value = azurerm_data_factory.default.id
}