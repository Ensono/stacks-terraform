############################################
# AUTHENTICATION
############################################
# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment
############################################
# NAMING
############################################

variable "name_company" {
  type = string

  default = "example"
}

variable "name_project" {
  type = string

  default = "stacks"

}

variable "name_component" {
  type = string

  default = "app"
}

variable "name_domain" {
  type = string

  default = "cosmos"
}

variable "stage" {
  type = string

  default = "dev"
}

variable "attributes" {
  default = []
}

variable "tags" {
  type = map(string)

  default = {}
}

# Each region must have corresponding a shortend name for resource naming purposes
variable "location_name_map" {
  type = map(string)

  default = {
    northeurope   = "eun"
    westeurope    = "euw"
    uksouth       = "uks"
    ukwest        = "ukw"
    eastus        = "use"
    eastus2       = "use2"
    westus        = "usw"
    eastasia      = "ase"
    southeastasia = "asse"
  }
}

############################################
# AZURE INFORMATION
############################################

variable "resource_group_location" {
  type = string

  default = "westeurope"
}

# variable "app_gateway_frontend_ip_name" {
#   type        = string
#   default     = "ed-stacks-nonprod-euw-core"
# }

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_cosmosdb" {
  type = bool

  default = true
}

variable "create_cache" {
  type = bool

  default = false
}

variable "create_dns_record" {
  type = bool

  default = false
}

variable "create_cdn_endpoint" {
  type = bool

  default = false
}

###########################
# CosmosDB SETTINGS
##########################
variable "cosmosdb_sql_container" {
  type = string

  default = "Menu"
}

variable "cosmosdb_sql_container_partition_key" {
  type = string

  default = "/id"
}

variable "cosmosdb_kind" {
  type = string

  default = "GlobalDocumentDB"
}
variable "cosmosdb_offer_type" {
  type = string

  default = "Standard"
}
