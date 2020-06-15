############################################
# AUTHENTICATION
############################################
# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment
############################################
# NAMING
############################################

variable "name_company" {
  type    = string
  default = "amido"
}

variable "name_project" {
  type    = string
  default = "stacks-node"

}

variable "name_component" {
  type    = string
  default = "infra"
}

variable "stage" {
  type    = string
  default = "nonprod"
}

variable "attributes" {
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

############################################
# AZURE INFORMATION
############################################

# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment

variable "client_secret" {
  type = string
}

############################################
# RESOURCE INFORMATION
############################################
variable "resource_group_location" {
  type    = string
  default = "uksouth"
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

# ###########################
# # DNS SETTINGS
# ##########################
variable "dns_zone" {
  type    = string
  default = "nonprod.amidostacks.com"
}

variable "internal_dns_zone" {
  type    = string
  default = "nonprod.amidostacks.internal"
}

variable "pfx_password" {
  type = string
  default = "Password1"
}


# ###########################
# # CONDITIONALS
# ##########################
variable "create_dns_zone" {
  type    = bool
  default = true
}

variable "create_aksvnet" {
  type    = bool
  default = true
}

variable "create_user_identiy" {
  type    = bool
  default = true
}


variable "create_acr" {
  type = bool
  default = true
}

###########################
# AppGateway SETTINGS
##########################

variable "ssl_policy" {
  type = object({policy_type=string,policy_name=string,min_protocol_version=string,disabled_protocols=list(string),cipher_suites=list(string)})
  description = "SSL policy definition, defaults to latest Predefined settings with min protocol of TLSv1.2"
  default = {
    "policy_type"="Predefined",
    "policy_name"="AppGwSslPolicy20170401S",
    "min_protocol_version"="TLSv1_2",
    "disabled_protocols"=null,
    "cipher_suites"=null
  }
}
