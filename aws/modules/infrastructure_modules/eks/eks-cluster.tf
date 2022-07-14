# EKS Cluster 
#############
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  vpc_id                          = module.vpc.vpc_id
  subnets                         = module.vpc.private_subnets
  cluster_name                    = local.cluster_name
  cluster_version                 = var.cluster_version
  enable_irsa                     = var.enable_irsa
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_enabled_log_types = ["scheduler", "controllerManager", "authenticator", "audit", "api"]

  cluster_encryption_config = [
    {
      resources        = ["secrets"]
      provider_key_arn = module.eks_kms_key.arn
    }
  ]
  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [for i, s in module.vpc.private_subnets : {
    name                   = "${local.cluster_name}_worker-group-${i}"
    subnets                = [s]
    instance_type          = "t2.medium"
    asg_desired_capacity   = ceil(var.eks_desired_nodes / length(module.vpc.private_subnets))
    root_volume_type       = "gp3"
    root_volume_throughput = 125
    root_volume_size       = 80
    root_encrypted         = true
    tags = [
      {
        "key"                 = "k8s.io/cluster-autoscaler/enabled"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
        "propagate_at_launch" = "false"
        "value"               = "owned"
      }
    ]
  }]

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",       # The policy for Amazon EC2 Role to enable AWS Systems Manager service core functionality.
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",        # Grant permissions that the CloudWatch agent needs to write metrics to CloudWatch.
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",            # Provides read/write access to AWS Secrets Manager.
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser" # Grant permissions to read and write to respositores, as well as read lifecycle policies 
  ]

  map_roles = var.map_roles
  map_users = var.map_users
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
