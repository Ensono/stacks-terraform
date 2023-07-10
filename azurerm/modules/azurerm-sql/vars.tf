############################################
# NAMING
############################################

variable "resource_namer" {
  type        = string
  description = "User defined naming convention applied to all resources created as part of this module"
}

variable "resource_tags" {
  description = "Map of tags to be applied to all resources created as part of this module"
  type        = map(string)
  default     = {}
}

variable "name_component" {
  default     = "sql"
  description = "Component Name - should/will be used in conventional resource naming. Typically this will be a logical name for this part of the system i.e. `API` || `middleware` or more generic like `Billing`"
  type        = string
}

############################################
# RESOURCE INFORMATION
############################################

variable "resource_group_location" {
  type        = string
  default     = "uksouth"
  description = "Location of Resource group"
}

variable "resource_group_name" {
  type        = string
  description = "name of resource group"
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
# SQL INFORMATION
############################################

variable "sql_db_names" {
  type        = list(string)
  default     = ["sqldbtest"]
  description = "The name of the MS SQL Database. Changing this forces a new resource to be created."
}

variable "sample_name" {
  type        = string
  default     = "AdventureWorksLT"
  description = "Specifies the name of the sample schema to apply when creating this database. Possible value is AdventureWorksLT"
}

variable "sql_version" {
  type        = string
  default     = "12.0"
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created."
}

variable "administrator_login" {
  type        = string
  sensitive   = true
  description = "The administrator login name for the new server. Required unless azuread_authentication_only in the azuread_administrator block is true. When omitted, Azure will generate a default username which cannot be subsequently changed. Changing this forces a new resource to be created."
}

variable "azuread_administrator" {
  type = list(object({
    login_username = string
    object_id      = string
  }))
  description = "Specifies whether only AD Users and administrators (like azuread_administrator.0.login_username) can be used to login, or also local database users (like administrator_login). When true, the administrator_login and administrator_login_password properties can be omitted."
  default     = []


}

variable "create_mode" {
  type        = string
  default     = "Default"
  description = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. Changing this forces a new resource to be created."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether public network access is allowed for this server. Defaults to true."
}


variable "sql_fw_rules" {
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "Allows you to manage an Azure SQL Firewall Rule."
  default = [
    {
      name             = "SQLFirewallRule1"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  ]

}

variable "collation" {
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
  description = "Specifies the collation of the database. Changing this forces a new resource to be created."
}

variable "license_type" {
  type        = string
  default     = "LicenseIncluded"
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
}

variable "sku_name" {
  type        = string
  default     = "Basic"
  description = "Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource."
}

variable "zone_redundant" {
  type        = bool
  default     = false
  description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
}

variable "auto_pause_delay_in_minutes" {
  type        = number
  default     = 60
  description = "Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for General Purpose Serverless databases."
}

############################################
# Private Endpoint INFORMATION
############################################

variable "enable_private_network" {
  type        = bool
  default     = false
  description = "Determines if the Key Vault will be created as part of the Secure Data Platform."
}

variable "is_manual_connection" {
  type        = bool
  default     = false
  description = "Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created."
}

variable "private_dns_zone_name" {
  type        = string
  default     = "privatelink.database.windows.net"
  description = "Specifies the Name of the Private DNS Zone Group."
}

variable "dns_resource_group_name" {
  type        = string
  default     = "amido-stacks-euw-de-hub-network"
  description = "Name of the resource group where pvt dns is present."
}

variable "pe_subnet_id" {
  type        = string
  default     = ""
  description = "ID for the Private Endpoint Subnet"
}

variable "pe_resource_group_name" {
  type        = string
  default     = ""
  description = "Name of the resource group to provision private endpoint in."
}

variable "pe_resource_group_location" {
  type        = string
  default     = ""
  description = "Location of the resource group to provision private endpoint in."
}
