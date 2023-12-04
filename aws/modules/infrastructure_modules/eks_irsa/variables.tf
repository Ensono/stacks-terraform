

variable "cluster_name" {
  type        = string
  description = "Name of Kubernetes cluster"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "EKS cluster OIDC url"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account id to configure irsa role"
}

variable "policy_prefix" {
  type        = string
  description = "A prefix to use for the policies, which will be spliced with a dash."

  default = ""
}

variable "policy" {
  type        = string
  description = "Policy json to apply to the irsa role"
}

variable "policy_path" {
  type        = string
  description = "The path to put the policy under, if not null the cluster_name will be used as the path"

  default = null
}

variable "resource_description" {
  type        = string
  description = "The description to assign to the policy and role"
}

variable "namespace" {
  type        = string
  description = "Name of Kubernetes namespace"
}

variable "service_account_name" {
  type        = string
  description = "Name of Kubernetes service account"
}
