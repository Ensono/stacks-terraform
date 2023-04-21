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
  default     = "premium"
  description = "The SKU to use for the databricks instance"

  validation {
    condition     = can(regex("standard|premium|trial", var.databricks_sku))
    error_message = "Err: Valid options are 'standard', 'premium' or 'trial'."
  }
}


############################################
# Resource Diagnostic Setting 
############################################

variable "enable_databricksws_diagnostic" {
  type        = bool
  description = "Whether to enable diagnostic settings for the Azure Databricks workspace"
  default     = false
}

variable "databricksws_diagnostic_setting_name" {
  type        = string
  default     = "Databricks to Log Analytics"
  description = "The Databricks workspace diagnostic setting name."
}

variable "data_platform_log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "The Log Analytics Workspace used for the whole Data Platform."
}

############################################
# Resource Databricks workspace setting 
############################################

variable "enable_enableDbfsFileBrowser" {
  type        = bool
  description = "Whether to enable Dbfs File browser for the Azure Databricks workspace"
  default     = false
}


############################################
# Resource Databricks user 
############################################

variable "add_rbac_users" {
  description = "If set to true, the module will create databricks users and  group named 'project_users' with the specified users as members, and grant workspace and SQL access to this group. Default is false."
  type        = bool
  default     = true
}

variable "rbac_databricks_users" {
  type = map(object({
    display_name = string
    user_name    = string
    active       = bool
  }))
  description = "If 'add_rbac_users' set to true then specifies RBAC Databricks users"
  default     = null
}

variable "databricks_group_display_name" {
  type        = string
  description = "If 'add_rbac_users' set to true then specifies databricks group display name"
  default     = "project_users"
}

variable "enable_workspace_access" {
  type        = bool
  description = "If 'add_rbac_users' set to true then specifies this"
  default     = true
}

variable "enable_sql_access" {
  type        = bool
  description = "If 'add_rbac_users' set to true then specifies this"
  default     = true
}