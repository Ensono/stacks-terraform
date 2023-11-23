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

variable "dns_resource_group" {
  type        = string
  description = "RG that contains the existing DNS zones, if the zones are not being created here"
  default     = null
}

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_ssl_cert" {
  type    = bool
  default = true
}

variable "disable_complete_propagation" {
  type    = bool
  default = false
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
  # NOTE: If you use `policy_type` as `Predefined`, the three variables,
  # `min_protocol_version`, `disabled_protocols`, and `cipher_suites`
  # will be ignored and TF will keep trying to apply them each run...
  type = object(
    {
      policy_type          = string,
      policy_name          = string,
      min_protocol_version = optional(string, null),
      disabled_protocols   = optional(list(string), null),
      cipher_suites        = optional(list(string), null),
    }
  )

  description = "SSL policy definition, defaults to latest Predefined settings with min protocol of TLSv1.2"

  default = {
    "policy_type" = "Predefined",
    "policy_name" = "AppGwSslPolicy20220101",
  }
}

variable "cert_name" {
  type        = string
  default     = "sample.cert.pfx"
  description = "Certificate name stored under certs/ locally, to be used for SSL appgateway"
}

variable "create_valid_cert" {
  type        = bool
  default     = true
  description = "States if a certificate should be requested from LetsEncrypt (true) or a self-signed certificate should be generated (false)"
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

variable "acme_email" {
  type        = string
  description = "Email for Acme registration, must be a valid email"
}
