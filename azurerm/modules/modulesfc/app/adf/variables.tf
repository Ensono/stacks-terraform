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

variable "use_key_vault" {
  type        = bool
  description = "Use Key Vault"
  default     = true
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault. Can be set to null if use_key_vault is false"
}

variable "github_configuration" {
  type = object({
    account_name    = string
    branch_name     = string
    git_url         = string
    repository_name = string
    root_folder     = string
  })
  description = "GitHub configuration for ADF version control"
  default     = null
}

variable "azure_devops_configuration" {
  type = object({
    account_name    = string
    branch_name     = string
    project_name    = string
    repository_name = string
    root_folder     = string
    tenant_id       = string
  })
  description = "VSTS configuration for ADF version control"
  default     = null
}
