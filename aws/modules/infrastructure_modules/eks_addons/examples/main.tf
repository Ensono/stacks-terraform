# EKS Addon Module To enable observability

module "eks-addon-observability" {
  source       = "../"
  cluster_name = "demo-eks-cluster"
}

output "cloudwatch_observability_addon_arn" {
  description = "cloudwatch observability addon arn"
  value       = module.eks-addon-observability.cloudwatch_observability_addon_arn
}
