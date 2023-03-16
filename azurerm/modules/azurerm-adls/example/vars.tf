############################################
# NAMING
############################################

variable "name_company" {
  description = "Company Name - should/will be used in conventional resource naming"
  type        = string
}

variable "name_project" {
  description = "Project Name - should/will be used in conventional resource naming"
  type        = string
}

variable "name_component" {
  description = "Component Name - should/will be used in conventional resource naming. Typically this will be a logical name for this part of the system i.e. `API` || `middleware` or more generic like `Billing`"
  type        = string
}

variable "name_environment" {
  type = string
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "attributes" {
  description = "Additional attributes for tagging"
  default     = []
}

variable "tags" {
  description = "Tags to be assigned to all resources, NB if global tagging is enabled these will get overwritten periodically"
  type        = map(string)
  default     = {}
}


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
variable "storage_account_details" {
  type = map(object({
    account_tier      = string
    account_kind      = string
    name              = string
    hns_enabled       = bool
    create_containers = bool
    containers_name   = list(string)
  }))
  # default = {
  #   "account1" = {
  #     account_kind = "BlobStorage"
  #     account_tier = "Standard"
  #     hns_enabled  = false
  #     name         = "rishi"
  #   },
  #   "account2" = {
  #     account_kind = "BlobStorage"
  #     account_tier = "Premium"
  #     hns_enabled  = true
  #     name         = "adls"
  #   },
  # }
}

variable "container_access_type" {
  type        = string
  description = "value"
  default     = "private"
}
