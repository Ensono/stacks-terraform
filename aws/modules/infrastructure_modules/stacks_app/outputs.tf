################
# Route 53 Zones
################
output "route53_zone_zone_id" {
  description = "Zone ID of Route53 zone"
  value       = length(module.zones) > 0 ? module.zones[*].route53_zone_zone_id : null
}

output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = length(module.zones) > 0 ? module.zones[*].route53_zone_name_servers : null
}

output "route53_zone_name" {
  description = "Name of the Route53 zone"
  value       = length(module.zones) > 0 ? module.zones[*].route53_zone_name : null
}

############
# Dynamo DB
############
output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = length(module.dynamodb_table) > 0 ? module.dynamodb_table[*].dynamodb_table_arn : null
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = length(module.dynamodb_table) > 0 ? module.dynamodb_table[*].dynamodb_table_id : null
}
