output "id" {
  description = "The ID of the Key Vault."
  value       = var.create_kv ? azurerm_key_vault.example.0.id : ""
}


output "vault_uri" {
  description = "vault_uri "
  value       = var.create_kv ? azurerm_key_vault.example.0.vault_uri : ""
}
output "key_vault_name" {
  value = var.create_kv ? azurerm_key_vault.example.0.name : ""
}
output "private_endpoint_id" {
  description = "The ID of the Private Endpoint associated with the Key Vault."
  value       = azurerm_private_endpoint.pe[0].id
}
