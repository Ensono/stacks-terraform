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

variable "data_platform_log_analytics_workspace_id" {
  type        = string
  description = "Data Platform Log Analytics ID"
  default     = null
}

variable "platform_scope" {
  type        = string
  description = "Platform Scope"
}

variable "adls_storage_account_primary_dfs_endpoint" {
  type = string
}

variable "default_storage_account_primary_blob_endpoint" {
  type = string
}

variable "adls_storage_account_id" {
  type = string
}

variable "default_storage_account_id" {
  type = string
}