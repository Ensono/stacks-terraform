############################################
# AUTHENTICATION
############################################
# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment
############################################
# NAMING
############################################


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


############################################
# AZURE INFORMATION
############################################

# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment

############################################
# RESOURCE INFORMATION
############################################

variable "resource_group_location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_tags" {
  type    = map(string)
  default = {}
}

variable "resource_group_name" {
  type = string
}

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_ssl_cert" {
  type    = bool
  default = true
}


# ###########################
# # NETWORK SETTINGS
# ##########################

variable "vnet_name" {
  type    = string
  default = "changeme"
}

variable "vnet_cidr" {
  type = list(string)
}

variable "subnet_prefixes" {
  type    = list(string)
  default = [""]
}

variable "subnet_front_end_prefix" {
  type = string
}

variable "subnet_backend_end_prefix" {
  type = string
}

variable "subnet_names" {
  type    = list(string)
  default = [""]
}

# ###########################
# # DNS SETTINGS
# ##########################
variable "dns_zone" {
  type    = string
  default = ""
}

variable "aks_ingress_ip" {
  type = string
}

# ###########################
# # AKS SETTINGS
# ##########################

variable "aks_resource_group" {
  type = string
}

###########################
# AppGateway SETTINGS
##########################

variable "ssl_policy" {
  type        = object({ policy_type = string, policy_name = string, min_protocol_version = string, disabled_protocols = list(string), cipher_suites = list(string) })
  description = "SSL policy definition, defaults to latest Predefined settings with min protocol of TLSv1.2"
  default = {
    "policy_type"          = "Predefined",
    "policy_name"          = "AppGwSslPolicy20170401S",
    "min_protocol_version" = "TLSv1_2",
    "disabled_protocols"   = null,
    "cipher_suites"        = null
  }
}

variable cert_name {
  type = string
  default = "sample.cert.pfx"
  description = "Certificate name stored under certs/ locally, to be used for SSL appgateway"
}
###########################
# MISC SETTINGS
##########################

variable "resource_namer" {
  type    = string
  default = "genericname"
}

variable "pfx_password" {
  type    = string
  default = "Password1"
}

