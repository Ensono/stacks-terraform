# outputs.tf

output "cloudwatch_observability_addon_status" {
  description = "Status of the CloudWatch Observability EKS add-on"
  value       = aws_eks_addon.amazon_cloudwatch_observability.status
}
