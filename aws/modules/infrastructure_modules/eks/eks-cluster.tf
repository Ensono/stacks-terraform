# EKS Cluster 
#############
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  enable_irsa                     = var.enable_irsa
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_enabled_log_types = ["scheduler", "controllerManager", "authenticator", "audit", "api"]

  cluster_encryption_config = {
      resources        = ["secrets"]
      provider_key_arn = module.eks_kms_key.arn
    }

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  self_managed_node_group_defaults = {}

  self_managed_node_groups = {
    # Bottlerocket node group
    bottlerocket = {
      name = "bottlerocket-self-mng"

      platform      = "bottlerocket"
      ami_id        = data.aws_ami.eks_default_bottlerocket.id
      instance_type = "t2.medium"
    }

  iam_role_additional_policies = {
    SM = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"       # The policy for Amazon EC2 Role to enable AWS Systems Manager service core functionality.
    CW = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"        # Grant permissions that the CloudWatch agent needs to write metrics to CloudWatch.
    ScM = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"            # Provides read/write access to AWS Secrets Manager.
    CR = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser" # Grant permissions to read and write to respositores, as well as read lifecycle policies 
  }

  # map_roles = var.map_roles
  # map_users = var.map_users
}
}

data "aws_ami" "eks_default_bottlerocket" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${var.cluster_version}-x86_64-*"]
  }
}


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

# Route 53 
##########
module "route53_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  count = var.enable_zone ? 1 : 0
  zones = var.public_zones
}
