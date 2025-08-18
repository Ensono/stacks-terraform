#####
# KMS
#####
module "eks_kms_key" {
  source = "../../resource_modules/identity/kms_key"

  name                    = local.eks_kms_key_name
  description             = local.eks_kms_key_description
  deletion_window_in_days = local.eks_kms_key_deletion_window_in_days
  tags                    = local.eks_kms_key_tags
  policy                  = data.aws_iam_policy_document.eks_secret_encryption_kms_key_policy.json
  enable_key_rotation     = true
}

#############
# EKS Cluster
#############
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0.9"

  vpc_id                  = var.vpc_id
  subnet_ids              = var.vpc_private_subnets
  name                    = var.cluster_name
  kubernetes_version      = var.cluster_version
  enable_irsa             = true
  endpoint_private_access = var.cluster_endpoint_private_access
  endpoint_public_access  = var.cluster_endpoint_public_access

  security_group_additional_rules = var.cluster_security_group_additional_rules

  node_security_group_additional_rules         = var.node_security_group_additional_rules
  node_security_group_enable_recommended_rules = var.node_security_group_enable_recommended_rules

  enabled_log_types = var.cluster_enabled_log_types

  addons = local.cluster_addons

  create_kms_key         = var.create_kms_key
  kms_key_administrators = var.trusted_role_arn == "" ? [] : ["${data.aws_caller_identity.this.arn}", "${var.trusted_role_arn}"]

  encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.eks_kms_key.arn
  }

  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = var.cluster_creator_admin_permissions

  eks_managed_node_groups = local.eks_managed_node_groups

  tags = var.tags
}
