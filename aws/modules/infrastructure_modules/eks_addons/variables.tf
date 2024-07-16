# variables.tf

variable "cloudwatch_observability_enabled" {
  type        = bool
  description = "Whether to enable amazon cloudwatch observability"
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "addon_version" {
  description = "Version of the amazon-cloudwatch-observability add-on"
  type        = string
  default     = "v1.8.0-eksbuild.1"
}

variable "custom_config" {
  type        = map(any)
  description = "Custom configuration for CloudWatch Agent"
  default     = {}
}

variable "addon_resolve_conflicts_on_create" {
  type        = string
  description = "Define how to resolve parameter value conflicts when creating the EKS add-on"
  default     = "OVERWRITE"
}

variable "addon_resolve_conflicts_on_update" {
  type        = string
  description = "Define how to resolve parameter value conflicts when updating the EKS add-on"
  default     = "PRESERVE"
}
