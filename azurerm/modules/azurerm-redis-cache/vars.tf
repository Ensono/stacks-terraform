############################################
# AUTHENTICATION
############################################
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
  type    = string
  default = "uksouth"
}

variable "resource_group_name" {
  type = string
}
