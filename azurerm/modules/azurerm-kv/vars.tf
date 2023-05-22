

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

variable "create_kv" {
  type        = bool
  default     = true
  description = " set value wether to create a KV or not"
}


###########################
# KV SETTINGS
##########################

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = true
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys"

}

variable "soft_delete_retention_days" {
  type        = number
  default     = 7
  description = "number of days that items should be retained for once soft-deleted. This value can be between 7 and 90"
}

variable "purge_protection_enabled" {
  type        = bool
  default     = false
  description = "Is Purge Protection enabled for this Key Vault "
}

variable "enabled_for_template_deployment" {
  type        = bool
  default     = false
  description = "whether Azure Resource Manager is permitted to retrieve secrets from the key vault "
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = false
  description = "whether Azure Resource Manager is permitted to retrieve secrets from the key vault "
}

variable "create_kv_networkacl" {
  type        = bool
  default     = false
  description = "whether to create a acl for kv or not "
}
variable "sku_name" {
  type        = string
  default     = "standard"
  description = "he Name of the SKU used for this Key Vault. Possible values are standard and premium"
}


variable "key_permissions" {
  type        = list(string)
  default     = ["Get"]
  description = "List of key permissions"
}

variable "secret_permissions" {
  type        = list(string)
  default     = ["Get"]
  description = "List of secret permissions, must be one or more "
}

variable "storage_permissions" {
  type        = list(string)
  default     = ["Get"]
  description = "List of storage permissions, must be one or more from the following "
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  default     = []
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault "
}

variable "network_acls_ip_rules" {
  type        = list(string)
  default     = []
  description = "The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny "
}

variable "network_acl_default_action" {
  type        = string
  default     = "Deny"
  description = "he Name of the SKU used for this Key Vault. Possible values are standard and premium"
}

variable "network_acls_bypass" {
  type        = string
  default     = "AzureServices"
  description = "Specifies which traffic can bypass the network rules. Possible values are AzureServices and None"
}

variable "contributor_object_ids" {
  description = "A list of Azure active directory user,group or application object ID's that will have contributor role to the key vault"
  type        = list(string)
  default     = []
}

variable "reader_object_ids" {
  description = "A list of Azure active directory user,group or application object ID's that will have reader role to the key vault"
  type        = list(string)
  default     = []
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Allow public network access to Key Vault. Set as true or false."
}

variable "network_acls" {
  type = list(object({
    default_action             = string
    virtual_network_subnet_ids = list(string)
    ip_rules                   = list(string)
    bypass                     = list(string)
  }))
  default     = []
  description = "Network ACL Rules to apply to the Key Vault Instance."
}