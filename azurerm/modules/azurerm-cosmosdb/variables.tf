############################################
# NAMING
############################################

variable "resource_namer" {
  type        = string
  description = "User defined naming convention applied to all resources created as part of this module"
}

variable "resource_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources created as part of this module"

  default = {}
}

############################################
# COSMOSDB INFORMATION
############################################

variable "cosmosdb_sql_container" {
  type = string

  description = "Sql container name"
}

variable "cosmosdb_sql_container_partition_key" {
  type        = string
  description = "Partition key path, if multiple partition"
}


variable "cosmosdb_offer_type" {
  type        = string
  description = ""

  default = "Standard"
}

variable "cosmosdb_kind" {
  type        = string
  description = ""

  default = "GlobalDocumentDB"
}

############################################
# RESOURCE INFORMATION
############################################

variable "resource_group_location" {
  type = string

  default = "westeurope"
}

variable "resource_group_name" {
  type = string
}

###########################
# CONDITIONAL SETTINGS
##########################

variable "create_cosmosdb" {
  type = bool

  default = false
}
