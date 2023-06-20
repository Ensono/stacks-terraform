############################################
# NAMING
############################################
variable "vnet_name" {
  type        = string
  default     = ""
  description = "Name of the VNET which the VMSS will be provisioned."
}

variable "vnet_resource_group" {
  type        = string
  default     = ""
  description = "Name of the Resource Group in which the VNET is provisioned."
}

variable "subnet_name" {
  type        = string
  default     = ""
  description = "Name of the  Subnet which the VMSS will be provisioned."
}

variable "vmss_name" {
  type        = string
  default     = ""
  description = "Name of the VMSS"
}

variable "network_interface_name" {
  type        = string
  default     = "primary"
  description = "Name of the VMs NIC."
}

variable "ip_configuration_name" {
  type        = string
  default     = "primary"
  description = "Name of the IP Config on the VMs NIC."
}

############################################
# RESOURCE INFORMATION
############################################

variable "vmss_resource_group_location" {
  type        = string
  default     = "uksouth"
  description = "Location of Resource group"
}

variable "vmss_resource_group_name" {
  type        = string
  description = "name of resource group"
  default     = ""
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

variable "vmss_sku" {
  type        = string
  default     = "Standard_B4ms"
  description = "VM Size"
}

variable "vmss_instances" {
  type        = number
  default     = 1
  description = "Default number of instances within the scaleset."
}

variable "vmss_admin_username" {
  type        = string
  default     = ""
  description = "Username for Admin SSH Access to VMs."
}

variable "vmss_admin_password" {
  type        = string
  default     = ""
  description = "Password for Admin SSH Access to VMs."
}

variable "vmss_disable_password_auth" {
  type        = bool
  default     = false
  description = "Boolean to enable or disable password authentication to VMs."
}

variable "vmss_image_publisher" {
  type        = string
  default     = "Canonical"
  description = "Image Publisher."
}

variable "vmss_image_offer" {
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
  description = "Image offer. Eg UbuntuServer"
}

variable "vmss_image_sku" {
  type        = string
  default     = "22_04-lts-gen2"
  description = "Image SKU."
}

variable "vmss_image_version" {
  type        = string
  default     = "latest"
  description = "Version of VM Image SKU required."
}

variable "vmss_storage_account_type" {
  type        = string
  default     = "StandardSSD_LRS"
  description = "Storeage type used for VMSS Disk."
}

variable "vmss_disk_caching" {
  type        = string
  default     = "ReadWrite"
  description = "Disk Caching options."
}

variable "overprovision" {
  type        = bool
  default     = false
  description = "Bool to set overprovisioning."
}
