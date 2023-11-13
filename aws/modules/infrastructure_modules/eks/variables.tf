# EKS Cluster
variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Map of infrastructure tags."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to use for the Cluster and resources"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "The VPC Private Subnets to place EKS nodes into"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster and resources"
}

variable "cluster_version" {
  type        = string
  description = "Cluster Kubernetes Version"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Switch to enable private access"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Switch to enable public access"
}

variable "cluster_single_az" {
  type        = bool
  description = "Spin up the cluster in a single AZ"
}

variable "eks_minimum_nodes" {
  type        = string
  description = "The minimum number of nodes in the cluster, per AZ if 'cluster_single_az' is false"

  default = 1
}

variable "eks_desired_nodes" {
  type        = string
  description = "The initial starting number of nodes, per AZ if 'cluster_single_az' is false"

  default = 2
}

variable "eks_maximum_nodes" {
  type        = string
  description = "The maximum number of nodes in the cluster, per AZ if 'cluster_single_az' is false"

  default = 3
}

variable "eks_node_size" {
  type        = string
  description = "Configure desired no of nodes for the cluster"

  default = "t3.small"
}

variable "eks_node_type" {
  type        = string
  description = "The type of nodes to use for EKS"

  default = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.eks_node_type)
    error_message = "Value must be one of ON_DEMAND, or SPOT."
  }
}

# VPC Flow Logs
variable "noncurrent_version_expiry_days" {
  type        = number
  default     = 90
  description = "Specifies when noncurrent object versions expire"
}

variable "noncurrent_version_transition_days" {
  type        = number
  default     = 30
  description = "Specifies when noncurrent object versions transitions"
}

variable "standard_transition_days" {
  type        = number
  default     = 30
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
}

variable "glacier_transition_days" {
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

  default = ["."]
}
