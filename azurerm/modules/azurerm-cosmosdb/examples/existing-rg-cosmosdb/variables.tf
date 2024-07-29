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

  default = "cosmos"
}

variable "name_environment" {
  type = string

  default = "nonprod"
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

############################################
# RESOURCE INFORMATION
############################################
variable "resource_group_location" {
  type    = string
  default = "westeurope"
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
