# EKS Cluster
variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Map of infrastructure tags."
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR to create"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC and resources"
}

# VPC Flow Logs
variable "flow_log_noncurrent_version_expiry_days" {
  type        = number
  default     = 90
  description = "Specifies when noncurrent object versions expire"
}

variable "flow_log_noncurrent_version_transition_days" {
  type        = number
  default     = 30
  description = "Specifies when noncurrent object versions transitions"
}

variable "flow_log_standard_transition_days" {
  type        = number
  default     = 30
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
}

variable "flow_log_glacier_transition_days" {
  type        = number
  default     = 60
  description = "Number of days after which to move the data to the glacier storage tier"
}

variable "flow_log_expiry_days" {
  type        = number
  default     = 90
  description = "Number of days after which to expunge the objects"
}

variable "flow_log_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
  default     = false
}

variable "flow_log_allow_ssl_requests_only" {
  type        = bool
  description = "Set to 'true' to require requests to use Secure Socket Layer (HTTPS/SSL). This will explicitly deny access to HTTP requests"
  default     = true
}

# Firewall
variable "firewall_deletion_protection" {
  type        = bool
  description = "Whether to protect the firewall from deletion"

  default = true
}

variable "firewall_alert_log_retention" {
  type        = number
  description = "The firewall alert log retention in days"

  default = 7
}

variable "firewall_flow_log_retention" {
  type        = number
  description = "The firewall flow log retention in days"

  default = 7
}

variable "firewall_allowed_domain_targets" {
  type        = list(string)
  description = "The list of allowed domains which can make it through the firewall"

  default = []
}
