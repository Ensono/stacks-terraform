variable "data_factory_name" {
  type        = string
  description = "Data Factory Name"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "adls_storage_account_name" {
  type        = string
  description = "ADLS Storage Account Name"
}

variable "default_storage_account_name" {
  type        = string
  description = "Default Storage Account Name"
}

variable "platform_scope" {
  type        = string
  description = "Platform Scope"
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault Name"
}
