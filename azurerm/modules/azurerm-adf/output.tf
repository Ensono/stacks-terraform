output "adf_factory_id" {
  value = azurerm_data_factory.example.0.id
}

output "adf_account_name" {
  description = "Azure Data Factory Name"
  value       = azurerm_data_factory.example.0.name
}

output "adf_managed_identity" {
  description = "Azure Data Factory Name"
  value       = azurerm_data_factory.example.0.identity[0].principal_id
}
