output "adls_storage_account_id" {
  value       = azurerm_storage_account.adls_default.id
  description = "The ID of the Storage Account."
}

output "adls_storage_account_primary_dfs_endpoint" {
  value       = azurerm_storage_account.adls_default.primary_dfs_endpoint
  description = "The endpoint URL for DFS storage in the primary location."
}

output "default_storage_account_primary_blob_endpoint" {
  value       = azurerm_storage_account.adls_default.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}
