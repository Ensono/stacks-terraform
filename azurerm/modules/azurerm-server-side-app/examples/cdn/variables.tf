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

  default = "cdn"
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

variable "app_gateway_frontend_ip_name" {
  type = string

  default = "ed-stacks-nonprod-euw-core"
}

variable "dns_record" {
  type = string

  default = "example-app"
}

variable "dns_zone_name" {
  type = string

  default = "nonprod.stacks.ensono.com"
}

variable "dns_zone_resource_group" {
  type = string

  default = "stacks-ancillary-resources"
}

variable "infra_resource_group" {
  type = string

  default = "ed-stacks-nonprod-euw-core"
}

variable "internal_dns_zone_name" {
  type = string

  default = "nonprod.stacks.ensono.internal"
}

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_cosmosdb" {
  type = bool

  default = false
}

variable "create_cache" {
  type = bool

  default = false
}

variable "create_dns_record" {
  type = bool

  default = true
}

variable "create_cdn_endpoint" {
  type = bool

  default = true
}
