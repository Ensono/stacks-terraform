############################################
# AUTHENTICATION
############################################
############################################
# NAMING
############################################

variable "resource_namer" {
  type = string
  description = "User defined naming convention applied to all resources created as part of this module"
}

variable "resource_tags" {
  description = "Map of tags to be applied to all resources created as part of this module"
  type    = map(string)
  default = {}
}

############################################
# COSMOSDB INFORMATION
############################################

variable "cosmosdb_sql_container" {
  description = "Sql container name"
  type        = string
}

variable "cosmosdb_sql_container_partition_key" {
  description = "Partition key path, if multiple partition"
  type        = string
}


variable "cosmosdb_offer_type" {
  description = ""
  type        = string
  default     = "Standard"
}

variable "cosmosdb_kind" {
  description = ""
  type        = string
  default     = "GlobalDocumentDB"
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

###########################
# CONDITIONAL SETTINGS
##########################

variable "create_cosmosdb" {
  type    = bool
  default = false
}

