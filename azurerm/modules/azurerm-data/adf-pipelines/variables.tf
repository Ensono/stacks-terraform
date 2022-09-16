variable "data_factory_id" {
  type        = string
  description = "The ID of the data factory to deploy the pipelines to"
}

variable "data_factory_name" {
  type        = string
  description = "The name of the data factory to deploy the pipelines to"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group the data factory is in"
}