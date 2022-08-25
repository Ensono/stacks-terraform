variable "region" {
  type        = string
  description = "Region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "platform_scope" {
  type        = string
  description = "Platform Scope"
}

variable "mssql_server_enable" {
  type        = bool
  description = "Deploy an MSSQL Server and assosiated resources"
  default     = true
}
