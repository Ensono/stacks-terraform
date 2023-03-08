output "storage_account_id" {
  value       = azurerm_storage_account.storage_account_default.id
  description = "The ID of the Storage Account."
}

output "storage_account_primary_dfs_endpoint" {
  value       = azurerm_storage_account.storage_account_default.primary_dfs_endpoint
  description = "The endpoint URL for DFS storage in the primary location."
}

output "storage_account_primary_blob_endpoint" {
  value       = azurerm_storage_account.storage_account_default.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}
