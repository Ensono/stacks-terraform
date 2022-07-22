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

variable "adls_account_replication_type" {
  type        = string
  description = "The ADLS Storage Account replication type"
  default     = "LRS"
}

variable "adls_containers" {
  type        = set(string)
  description = "ADLS containers to create"
  default     = ["curated", "staging", "raw"]
}
