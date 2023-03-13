# This does not work as of yet. 
# output "storage_account_ids" {
#   value = { for k, v in azurerm_storage_account.storage_account_default : k => v.id }
# }
# output "primary_blob_endpoint" {
#   value = { for k, v in azurerm_storage_account.storage_account_default : k => v.primary_blob_endpoint }
# }
 

 output "storage_account_ids" {
   value =  { for i in azurerm_storage_account.storage_account_default : 
   i.name => {
    name = i.name
    id = i.id
   }}
 }


output "storage_account_ids_test" {
  value = values(azurerm_storage_account.storage_account_default)[*].id
}
