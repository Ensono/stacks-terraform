# EKS Cluster
variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Map of infrastructure tags."
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

variable "eks_minimum_nodes" {
  type        = string
  description = "The minimum number of nodes in the cluster"

  default = 1
}

variable "eks_desired_nodes" {
  type        = string
  description = "The initial starting number of nodes"

  default = 2
}

variable "eks_maximum_nodes" {
  type       = string
  description = "The maximum number of nodes in the cluster"

  default = 3
}

variable "eks_node_size" {
  type        = string
  description = "Configure desired no of nodes for the cluster"

  default = "t3.small"
}
