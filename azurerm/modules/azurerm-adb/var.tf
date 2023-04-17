############################################
# NAMING
############################################

variable "resource_namer" {
  type        = string
  description = "User defined naming convention applied to all resources created as part of this module"
}

variable "resource_tags" {
  description = "Map of tags to be applied to all resources created as part of this module"
  type        = map(string)
  default     = {}
}

############################################
# RESOURCE INFORMATION
############################################

variable "resource_group_location" {
  type        = string
  default     = "uksouth"
  description = "Location of Resource group"
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group"
}

variable "databricks_sku" {
  type        = string
  default    = "premium"
  description = "The SKU to use for the databricks instance"
 
  validation {
    condition     = can(regex("standard|premium|trial", var.databricks_sku))
    error_message = "Err: Valid options are 'standard', 'premium' or 'trial'."
  }
}


############################################
# Resource Diagnostic Setting 
############################################

variable "databricksws_diagnostic_setting_name" {
  type        = string
  default = "Databricks to Log Analytics"
  description = "The Databricks workspace diagnostic setting name."
}

variable "log_analytics_destination_type" {
  type        = string
  default = "Dedicated"
  description = "Possible values are AzureDiagnostics and Dedicated.When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table"
}

variable "data_platform_log_analytics_workspace_id" {
  type        = string
  description = "The Log Analytics Workspace used for the whole Data Platform."
}