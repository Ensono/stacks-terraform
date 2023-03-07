variable "region" {
  type        = string
  description = "Region"
  default     = "northeurope"
}

variable "account_kind" {
  type        = string
  description = "(OPTIONAL) Defines the Kind of account - available options are: BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing the account_kind value from Storage to StorageV2 will not trigger a force new on the storage account, it will only upgrade the existing storage account from Storage to StorageV2 keeping the existing storage account in place."
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "hns_enabled" {
  type        = bool
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created."
  default     = true
}

variable "blob_type" {
  type        = string
  description = "The type of the storage blob to be created. Possible values are Append, Block or Page"
  default     = "Block"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "adls_account_replication_type" {
  type        = string
  description = "The ADLS Storage Account replication type"
  default     = "LRS"
}

variable "adls_containers" {
  type        = set(string)
  description = "ADLS containers to create, for example: curated, staging, raw"
  default     = ["curated", "staging", "raw"]
}

variable "resource_namer" {
  description = "This should be a uniformly created string - ideally using something like cloudposse label module to ensure conventions on naming are followed throughout organization. this value is used in all the places within the module to name resources - additionally it changes the string to ensure it conforms to Azure standards where appropriate - i.e. blob/KV/ACR names are stripped of non alphanumeric characters and in some cases strings are sliced to conform to max char length"
  type        = string
  default     = "genericname"
}

############################################
# NAMING
############################################

variable "storage_account_name" {
  description = "Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
  type        = string

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