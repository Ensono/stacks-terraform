module "amido_stacks_infra" {
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

  # Pass Non-default Tag Values to Underlying Modules
  tags = {}
}
