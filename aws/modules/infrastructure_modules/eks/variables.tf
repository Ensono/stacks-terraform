# EKS Cluster
variable "region" {

  description = "AWS region"
  type        = string
}

variable "map_users" {

  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "map_roles" {

  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

}


variable "tags" {

  description = "Map of infrastructure tags."
  type        = map(string)

}


variable "cluster_name" {

  description = "Name of the cluster"
  type        = string
}

variable "cluster_version" {

  description = "Cluster Kubernetes Version"
  type        = string
}

variable "enable_irsa" {

  description = "Switch to ebale IRSA"
  type        = bool
}

variable "cluster_endpoint_private_access" {

  description = "Switch to enable private access"
  type        = bool
}

variable "cluster_endpoint_public_access" {

  description = "Switch to enable public access"
  type        = bool
}

variable "eks_desired_nodes" {

  description = "Configure desired no of nodes for the cluster"
  type        = string
}

# Route 53 Zones
variable "enable_zone" {
  description = "Conditionally create route53 zones"
  type        = number
}
variable "public_zones" {
  type        = map(any)
  description = "Map of Route53 zone parameters"
}
