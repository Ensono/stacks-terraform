############################################
# AUTHENTICATION
############################################
# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment
############################################
# NAMING
############################################

variable "name_company" {
  type    = string
  default = "replace_company_name"
}

variable "name_project" {
  type    = string
  default = "replace_project_name"

}

variable "name_component" {
  type    = string
  default = "replace_component_name"
}

variable "name_domain" {
  type    = string
  default = "replace_domain_name"
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "attributes" {
  default = []
}

variable "tags" {
  type    = map(string)
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
  type    = string
  default = "uksouth"
}

variable "app_gateway_frontend_ip_name" {
  description = ""
  type = string
}

variable "dns_record" {
  description = ""
  type = string
  default = "app"
}

variable "dns_zone_name" {
  type    = string
  default = "nonprod.amidostacks.com"
}

variable "dns_zone_resource_group" {
  type    = string
  default = ""
}

variable "core_resource_group" {
  type    = string
}

variable "internal_dns_zone_name" {
  type    = string
  default = "nonprod.amidostacks.internal"
}


###########################
# CONDITIONAL SETTINGS
##########################
variable "create_cosmosdb" {
  description = "Whether to create a cosmosdb or not for this application"
  type    = bool
  default = true
}

variable "create_cache" {
  type = bool
  description = "Whether to create a RedisCache"
  default = false
}

variable "create_dns_record" {
  type = bool
  default = false
}

variable create_cdn_endpoint {
  type = bool
  default = false
}
###########################
# CosmosDB SETTINGS
##########################
variable "cosmosdb_sql_container" {
  type = string
  description = "Specify the SQLContainer name in CosmosDB"
  default = "Menu"
}

variable "cosmosdb_sql_container_partition_key" {
  type = string
  default = "/id"
  description = "Specify partition key"
}

variable "cosmosdb_kind" {
  type = string
  default = "GlobalDocumentDB"
  description = "Specify the CosmosDB kind"
}
variable "cosmosdb_offer_type" {
  type = string
  default = "Standard"
  description = "Specify the offer type"
}
