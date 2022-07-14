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

variable "storage_account_name" {
  type        = string
  description = "Storage Account Name"
}

variable "data_platform_log_analytics_workspace_id" {
  type        = string
  description = "Data Platform Log Analytics ID"
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
  default     = ["dev"]
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
