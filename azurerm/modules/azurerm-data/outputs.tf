output "ADLS_STORAGE_ACCOUNT_NAME" {
  value = azurerm_storage_account.adls.name
}

output "ADF_BLOB_LINKED_SERVICE_NAME" {
  description = "BLOB LInked Service Name"
  value       = "ls_blob"
}

output "ADF_STORAGE_ACCOUNT_NAME" {
  description = "The name of the ADF Storage Account"
  value       = azurerm_storage_account.default.name
}

output "RESOURCE_GROUP_NAME" {
  description = "Resource Group name."
  value       = azurerm_resource_group.default.name
}

output "ADF_ACCOUNT_NAME" {
  description = "Azure Data Factory Name"
  value       = azurerm_data_factory.default.name
}
