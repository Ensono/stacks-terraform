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
