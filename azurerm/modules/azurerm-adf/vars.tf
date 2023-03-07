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

variable "name_component" {
  default     = "kv"
  description = "Component Name - should/will be used in conventional resource naming. Typically this will be a logical name for this part of the system i.e. `API` || `middleware` or more generic like `Billing`"
  type        = string
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
  description = "name of resource group"
}

###########################
# CONDITIONAL SETTINGS
##########################

variable "create_adf" {
  type        = bool
  default     = true
  description = " set value wether to create a KV or not"
}

###########################
# ADF Identity SETTINGS
##########################

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = " Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned,UserAssigned (to enable both)"
}

variable "identity_ids" {
  type        = list(string)
  default     = []
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Data Factory."
}

variable "adf_idenity" {
  type        = bool
  default     = true
  description = "enable idenity block in module"
}

###########################
# ADF SETTINGS
##########################

variable "public_network_enabled" {
  type        = bool
  default     = true
  description = "Is the Data Factory visible to the public network? Defaults to"
}

variable "managed_virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Is Managed Virtual Network enabled?"
}


###########################
# ADF git hub SETTINGS
##########################
variable "github_enabled" {
  type        = bool
  default     = false
  description = "A github_configuration block for ADF integration ?"
}

variable "account_name" {
  type        = string
  default     = "amido"
  description = "Specifies the GitHub account name."
}


variable "branch_name" {
  type        = string
  default     = "feature/test"
  description = "Specifies the branch of the repository to get code from"
}

variable "git_url" {
  type        = string
  default     = "https://github.com"
  description = "specifies the GitHub Enterprise host name. For example: https://github.mydomain.com. Use https://github.com for open source repositories."
}


variable "repository_name" {
  type        = string
  default     = "stacks"
  description = "Specifies the name of the git repository"
}

variable "root_folder" {
  type        = string
  default     = "/"
  description = "Specifies the root folder within the repository. Set to / for the top level."
}
