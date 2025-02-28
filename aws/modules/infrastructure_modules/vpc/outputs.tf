output "id" {
  description = "The ID of the VPC Created by this module."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets created by this module."
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets created by this module."
  value       = aws_subnet.public.*.id
}

output "database_subnet_ids" {
  description = "The IDs of the database subnets created by this module."
  value       = module.vpc.database_subnets
}

output "lambda_subnet_ids" {
  description = "The IDs of the Lambda subnets created by this module."
  value       = aws_subnet.lambda.*.id
}

output "firewall_subnet_ids" {
  description = "The IDs of the Network Firewall subnets created by this module."
  value       = aws_subnet.network_firewall.*.id
}

output "private_route_table_ids" {
  description = "The IDs of the private routing tables"
  value       = module.vpc.private_route_table_ids
}

output "private_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets created by this module."
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets created by this module."
  value       = aws_subnet.public.*.cidr_block
}

output "database_subnet_cidrs" {
  description = "The CIDR blocks of the database subnets created by this module."
  value       = module.vpc.private_subnets_cidr_blocks
}

output "database_subnet_group_name" {
  description = "RDS Database subnet name. This is the name of the RDS subnet which includes the VPC subnets"
  value       = module.vpc.database_subnet_group_name
}


output "lambda_subnet_cidrs" {
  description = "The CIDR blocks of the lambda subnets created by this module."
  value       = aws_subnet.lambda.*.cidr_block
}

output "firewall_subnet_cidrs" {
  description = "The CIDR blocks of the Network Firewall subnets created by this module."
  value       = aws_subnet.network_firewall.*.cidr_block
}

output "sorted_vpc_zone_ids" {
  description = "The sorted AZ Zone IDs"
  value       = local.sorted_azs
}

output "sorted_vpc_zone_ids_map" {
  description = "The sorted AZ Zone IDs as a map"
  value       = local.sorted_azs_map
}
