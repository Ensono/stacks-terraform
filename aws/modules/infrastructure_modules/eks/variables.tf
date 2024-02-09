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

variable "eks_node_tenancy" {
  type        = string
  description = "The tenancy of the node instance to use for EKS"

  default = "default"

  validation {
    condition     = contains(["default", "dedicated", "host"], var.eks_node_tenancy)
    error_message = "Value must be one of 'default', 'dedicated', or 'host'."
  }
}
