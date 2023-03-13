output "storage_id_1" {
  value = module.adls_default.storage_account_ids[0]
}

output "storage_account_names" {
  value = module.adls_default.storage_account_ids[*]
}

output "storage_ids" {
  value = module.adls_default.storage_account_ids[*]
}
