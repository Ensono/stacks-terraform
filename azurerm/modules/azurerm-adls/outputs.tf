# This does not work as of yet. 
# output "storage_account_ids" {
#   value = { for k, v in azurerm_storage_account.storage_account_default : k => v.id }
# }
# output "primary_blob_endpoint" {
#   value = { for k, v in azurerm_storage_account.storage_account_default : k => v.primary_blob_endpoint }
# }


output "storage_account_ids" {
  value = values(azurerm_storage_account.storage_account_default)[*].id
}

output "storage_account_names" {
  value = values(azurerm_storage_account.storage_account_default)[*].name
}

output "storage_account_id_1" {
  value = values(azurerm_storage_account.storage_account_default)[0].id
}

output "storage_account_primary_connection_string" {
  value     = values(azurerm_storage_account.storage_account_default)[*].primary_connection_string
  sensitive = true
}

output "primary_blob_connection_string" {
  value     = values(azurerm_storage_account.storage_account_default)[*].primary_connection_string
  sensitive = true
}