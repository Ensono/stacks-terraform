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

variable "enable_cis_bootstrap" {
  description = "Set to true to enable the CIS Boostrap, false to disable."
  type        = bool
  default     = false
}

variable "cis_bootstrap_image" {
  description = "CIS Bootstrap image, required if enable_cis_bootstrap is set to true"
  type        = string
  default     = ""
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "Node all egress"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      type                       = "egress"
      source_node_security_group = true
    }
  }
}

variable "trusted_role_arn" {
  description = "IAM role passed to KMS Policy"
  type        = string
  default     = ""
}

variable "image_gc_high_threshold_percent" {
  description = "The percent of disk usage that initiates image garbage collection by kubelet. This value must be greater than the low threshold value"
  type        = number
  default     = 85
}

variable "image_gc_low_threshold_percent" {
  description = "The kubelet deletes images until disk usage reaches this value. This value must be less than the high threshold value"
  type        = number
  default     = 80
}

variable "create_kms_key" {
  description = "[ Warn: breaking-change ] Making this value false will allow passing a custom KMS key via the provider_key_arn configuration"
  type        = bool
  default     = true
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group created. Set source_cluster_security_group = true inside rules to set the cluster_security_group as source"
  type        = any
  default = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

variable "node_security_group_enable_recommended_rules" {
  description = "Determines whether to enable recommended security group rules for the node security group created. This includes node-to-node TCP ingress on ephemeral ports and allows all egress traffic"
  type        = bool
  default     = true
}

variable "block_device_mappings" {
  description = "Allow you to override the volumes to attach to the instances. This is useful if you want to increase the volume where the container image layers are stored. Default is 20gb"
  default     = {}
}

variable "node_iam_assume_role_policy" {
  description = "Allowing you to override the assume role policy assigned to the node group IAM Role. If this is set then this module will create the IAM Role and attach this trust policy to it."
  default     = null
}
