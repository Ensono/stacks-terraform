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
  version = "~> 19.20"

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.vpc_private_subnets
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  enable_irsa                     = true
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "Node all egress"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
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

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.eks_kms_key.arn
  }

  # OIDC Identity provider
  cluster_identity_providers = {
    sts = {
      client_id = "sts.amazonaws.com"
    }
  }

  # Don't manage this through the module, it's incredibly hard to get working right.
  create_aws_auth_configmap = false
  manage_aws_auth_configmap = false

  eks_managed_node_group_defaults = {
    disk_size = 50
    placement = {
      tenancy = var.eks_node_tenancy
    }
  }

  eks_managed_node_groups = local.eks_managed_node_groups

  tags = var.tags
}
