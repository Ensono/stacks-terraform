######################################### Azure resource group variables ######################################### 

variable "resource_group_name" {
  type        = string
  description = "he Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
  default     = "network-test"
}

variable "existing_resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = null

}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
  default     = "uksouth"
}

variable "enable_private_networks" {
  description = "wether to creare private networks or not."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to be applied to all resources created as part of this module"
  type        = map(string)
  default     = {}
}

######################################### Azure Firewall variables ######################################### 

variable "create_hub_fw" {
  description = "weather to create a Azure fierwall in hub network"
  type        = bool
  default     = false
}

variable "create_fw_public_ip" {
  description = "weather to create a  public IP for Azure fierwall in hub network"
  type        = bool
  default     = false
}

variable "fw_public_ip_name" {
  description = "Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
  type        = string
  default     = "testip"
}

variable "fw_public_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  type        = string
  default     = "Dynamic"
}

variable "fw_public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. Changing this forces a new resource to be created."
  type        = string
  default     = "Basic"
}

variable "hub_fw_address_prefixes" {
  description = "Addess prefix for hub azure firewall"
  type        = list(string)
  default     = ["10.1.20.0/26"]
}

variable "name_az_fw" {
  description = "Specifies the name of the Firewall. Changing this forces a new resource to be created."
  type        = string
  default     = "testfirewall"
}

variable "sku_az_fw" {
  description = "SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created."
  type        = string
  default     = "AZFW_Hub"
}

variable "sku_tier_az_fw" {
  description = "SKU tier of the Firewall. Possible values are Premium, Standard and Basic."
  type        = string
  default     = "Basic"
}

variable "ip_config_name_az_fw" {
  description = "Specifies the name of the IP Configuration."
  type        = string
  default     = "ip_configuration"
}

#########################################  Azure Vnet and Subnet variables   #########################################

variable "network_details" {
  type = map(object({
    name          = string
    address_space = list(string),
    dns_servers   = list(string),
    is_hub        = bool
    subnet_details = map(object({
      sub_name                                      = string,
      sub_address_prefix                            = list(string)
      private_endpoint_network_policies_enabled     = bool
      private_link_service_network_policies_enabled = bool
      })
    )

  }))

  default = {
    "network1" = {
      name          = "network1"
      address_space = ["10.1.0.0/16"]
      dns_servers   = ["10.1.0.4", "10.1.0.5"]
      is_hub        = true
      subnet_details = {
        "sub1" = {
          sub_name                                      = "subnet3"
          sub_address_prefix                            = ["10.1.1.0/24"]
          private_endpoint_network_policies_enabled     = true
          private_link_service_network_policies_enabled = true
        }

    } },


    "network2" = {
      name          = "network2"
      address_space = ["10.2.0.0/16"]
      dns_servers   = ["10.2.0.4", "10.2.0.5"]
      is_hub        = false
      subnet_details = {
        "sub1" = {
          sub_name                                      = "subnet1"
          sub_address_prefix                            = ["10.2.1.0/24"]
          private_endpoint_network_policies_enabled     = true
          private_link_service_network_policies_enabled = true
        },

        "sub2" = {
          sub_name                                      = "subnet2"
          sub_address_prefix                            = ["10.2.2.0/24"]
          private_endpoint_network_policies_enabled     = true
          private_link_service_network_policies_enabled = true
        }

    } },
    "network3" = {
      name          = "network3"
      address_space = ["10.3.0.0/16"]
      dns_servers   = ["10.3.0.4", "10.3.0.5"]
      is_hub        = false
      subnet_details = {
        "sub1" = {
          sub_name                                      = "subnet5"
          sub_address_prefix                            = ["10.3.1.0/24"]
          private_endpoint_network_policies_enabled     = true
          private_link_service_network_policies_enabled = true
        },

        "sub2" = {
          sub_name                                      = "subnet6"
          sub_address_prefix                            = ["10.3.2.0/24"]
          private_endpoint_network_policies_enabled     = true
          private_link_service_network_policies_enabled = true
        }

    } }

  }
}
