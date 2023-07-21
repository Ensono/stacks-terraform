############################################
# NAMING
############################################

variable "stage" {
  type    = string
  default = "dev"
}

variable "attributes" {
  description = "Additional attributes for tagging"
  default     = []
}

variable "tags" {
  description = "Tags to be assigned to all resources, NB if global tagging is enabled these will get overwritten periodically"
  type        = map(string)
  default     = {}
}

###########################
# OBSERVABILITY
##########################

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Name of the Data Platform Resource Group."
}

variable "resource_group_location" {
  description = "Location of the RG"
  type        = string
  default     = "useast"
}

variable "resource_group_tags" {
  description = "Tags at a RG level"
  type        = map(string)
  default     = {}
}

variable "retention_in_days" {
  type    = number
  default = 30
}

variable "log_application_type" {
  description = "Log application type"
  type        = string
  default     = "other"
}

variable "key_vault_name" {
  description = "Key Vault name - if not specificied will default to computed naming convention"
  type        = string
  default     = ""
}

variable "la_name" {
  type        = string
  default     = ""
  description = "Name of the Log Analtics Instance to be created."
}

variable "app_insights_name" {
  type        = string
  default     = ""
  description = "Name of the App Insights Instance to be created."
}



