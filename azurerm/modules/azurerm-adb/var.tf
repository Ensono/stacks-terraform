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

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Enables or Disabled Public Access to Databricks Workspace."
}

variable "network_security_group_rules_required" {
  type        = string
  default     = "NoAzureDatabricksRules"
  description = " Does the data plane (clusters) to control plane communication happen over private link endpoint only or publicly? Possible values AllRules, NoAzureDatabricksRules or NoAzureServiceRules."
}

variable "enable_private_network" {
  type        = bool
  default     = false
  description = "Enable Secure Data Platform."
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
  description = "Whether to enable workspace access for the databricks group"
  default     = true
}

variable "enable_sql_access" {
  type        = bool
  description = "Whether to enable sql access for the databricks group"
  default     = true
}

variable "nat_idle_timeout" {
  type        = number
  default     = 10
  description = "Idle timeout period in minutes."
}

############################################
# Network Details
############################################

variable "create_subnets" {
  type        = bool
  default     = false
  description = "Set to true if you need the module to create the subnets for you."
}

variable "vnet_name" {
  type        = string
  default     = ""
  description = "Name of the VNET inwhich the Databricks Workspace will be provisioned."
}

variable "vnet_resource_group" {
  type        = string
  default     = ""
  description = "The Resource Group which the VNET is provisioned."
}

variable "public_subnet_name" {
  type        = string
  default     = ""
  description = "Name of the Public Databricks Subnet."
}

variable "private_subnet_name" {
  type        = string
  default     = ""
  description = "Name of the Private Databricks Subnet."
}

variable "public_subnet_prefix" {
  type        = list(string)
  default     = []
  description = "IP Address Space fo the Public Databricks Subnet."
}

variable "private_subnet_prefix" {
  type        = list(string)
  default     = []
  description = "IP Address Space fo the Private Databricks Subnet."

}

variable "pe_subnet_name" {
  type        = string
  default     = ""
  description = "Name of the Subnet used to provision Private Endpoints into."
}

variable "vnet_address_prefix" {
  type        = string
  default     = ""
  description = "Address Prefix of the VNET."
}

variable "dns_record_ttl" {
  type        = number
  default     = 300
  description = "TTL for DNS Record."
}

variable "service_endpoints" {
  type        = list(string)
  default     = ["Microsoft.AzureActiveDirectory", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage"]
  description = "List of Service Endpoints Enabled on the Subnet."
}

variable "create_nat" {
  type        = bool
  default     = false
  description = "Deploy Databricks with a NAT Gateway."
}

variable "create_lb" {
  type        = bool
  default     = false
  description = "Deploy Databricks with a Load Balancer."
}