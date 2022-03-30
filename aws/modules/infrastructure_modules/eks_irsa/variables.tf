variable "namespace" {

  description = "Name of Kubernetes namespace"
}

variable "serviceaccount" {

  default     = ""
  description = "Name of Kubernetes serviceaccount"
}

variable "cluster" {

  default     = ""
  description = "Name of Kubernetes cluster"
}

variable "create_namespace" {

  default     = false
  description = "Enables creating the namespace"
}

variable "create_serviceaccount" {

  default     = false
  description = "Enables creating a serviceaccount"
}

variable "enable_irsa" {

  default     = false
  description = "Add irsa role for the serviceaccount"
}

variable "policy" {

  default     = ""
  description = "Policy json to apply to the irsa role"
}

variable "issuer_url" {

  default     = ""
  description = "EKS cluster OIDC url"
}

variable "aws_account_id" {

  default     = ""
  description = "AWS account id to configure irsa role"
}