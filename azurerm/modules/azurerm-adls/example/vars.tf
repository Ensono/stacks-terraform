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
  description = "Name of the environment"
  type        = string
}

variable "stage" {
  description = "Stage of the deployment"
  type        = string
  default     = "dev"
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
  description = "The default value for this variable includes two objects, data_config_storage and data_lake_storage. The data_config_storage object has BlobStorage type, standard tier, and a single config container. The data_lake_storage object has StorageV2 type, standard tier, Hierarchical Namespace enabled, and three containers named curated, staging, and raw. Depending on the value of `hns_enabled` it will create either a Blob storage, or Gen2 Data Lake filesystem, with the names specified in `containers_name`"

  type = map(object({
    account_tier    = string
    account_kind    = string
    name            = string
    hns_enabled     = bool
    containers_name = list(string)
  }))
  default = {
    "data_config_storage" = {
      account_kind    = "BlobStorage"
      account_tier    = "Standard"
      hns_enabled     = false
      name            = "config"
      containers_name = ["config"]
    },
    "data_lake_storage" = {
      account_kind    = "StorageV2"
      account_tier    = "Standard"
      hns_enabled     = true
      name            = "adls"
      containers_name = ["curated", "staging", "raw"]
    },
  }
}

variable "container_access_type" {
  type        = string
  description = "The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."
  default     = "private"
}
