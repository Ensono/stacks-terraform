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

variable "application_insights_daily_data_cap_in_gb" {
  type        = number
  description = "The daily cap in ingesting data, once reached no more data will be ingested for the period."
  default     = 5
}

variable "application_insights_daily_data_cap_notifications_disabled" {
  type        = bool
  description = "Enables or disables the daily cap notification."
  default     = true
}

variable "application_insights_retention_in_days" {
  type        = number
  description = "Number of days data is retained for - this only applies to the classic resource."
  default     = 30
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault Name"
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
