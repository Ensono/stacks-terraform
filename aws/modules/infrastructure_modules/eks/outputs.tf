output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.aws_auth_configmap_yaml
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_certificate_authority_data" {
  description = "base64 encoded certificate data required to communicate with your cluster"
  value       = module.eks.cluster_certificate_authority_data
}


#######
# OIDC 
######

output "cluster_oidc_provider" {
  description = "OpenID Connect identity provider without leading http"
  value       = module.eks.oidc_provider
}

output "cluster_oidc_provider_arn" {
  description = "OpenID Connect identity provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

################
# Route 53 Zones
################
output "route53_zone_zone_id" {
  description = "Zone ID of Route53 zone"
  value       = length(module.route53_zones) > 0 ? module.route53_zones[*].route53_zone_zone_id : null
}

output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = length(module.route53_zones) > 0 ? module.route53_zones[*].route53_zone_name_servers : null
}

output "route53_zone_name" {
  description = "Name of the Route53 zone"
  value       = length(module.route53_zones) > 0 ? module.route53_zones[*].route53_zone_name : null
}

