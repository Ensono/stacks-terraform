module "vpc" {
  source = "../../vpc"

  # Deployment Region
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "example-eks-vpc"

  firewall_deletion_protection = false

  tags = {}
}

module "eks" {
  source = "../"

  # Deployment Region
  region = "eu-west-1"

  # EKS Cluster Configuration
  cluster_name                    = "example-cluster"
  cluster_version                 = "1.27"
  eks_desired_nodes               = 1
  eks_node_size                   = "t3.small"
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_single_az               = false

  vpc_id              = module.vpc.id
  vpc_private_subnets = module.vpc.private_subnet_ids

  # Pass Non-default Tag Values to Underlying Modules
  tags = {}
}

provider "aws" {
  region = "eu-west-1"
}
