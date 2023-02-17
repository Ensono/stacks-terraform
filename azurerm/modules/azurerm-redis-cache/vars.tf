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

variable "minimum_tls_version" {
  type = string
  default = "1.2"
}

variable "redis_capacity" {
  type = string
  default = "1"
}

variable "redis_family" {
  type = string
  default = "C"
}

variable "redis_sku_name" {
  type = string
  default = "Standard"
}