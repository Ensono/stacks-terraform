output "ADLS_STORAGE_ACCOUNT_NAME" {
  value = var.adls_storage_account_name
}

output "ADF_BLOB_LINKED_SERVICE_NAME" {
  description = "BLOB Linked Service Name"
  value       = "ls_blob"
}

output "ADF_STORAGE_ACCOUNT_NAME" {
  description = "The name of the ADF Storage Account"
  value       = var.default_storage_account_name
}

output "RESOURCE_GROUP_NAME" {
  description = "Resource Group name."
  value       = var.resource_group_name
}

output "ADF_ACCOUNT_NAME" {
  description = "Azure Data Factory Name"
  value       = module.app.ADF_ACCOUNT_NAME
}

output "KEY_VAULT_NAME" {
  description = "Azure Key Vault Name"
  value       = var.key_vault_name
}

output "ADF_FACTORY_ID" {
  value = module.app.ADF_FACTORY_ID
}