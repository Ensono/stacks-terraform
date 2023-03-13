# This does not work as of yet. 
# output "storage_account_ids" {
#   value = { for k, v in azurerm_storage_account.storage_account_default : k => v.id }
# }
# output "primary_blob_endpoint" {
#   value = { for k, v in azurerm_storage_account.storage_account_default : k => v.primary_blob_endpoint }
# }
 