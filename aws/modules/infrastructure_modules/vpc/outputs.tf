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

output "private_route_table_ids" {
  description = "The IDs of the private routing tables"
  value       = module.vpc.private_route_table_ids
}

output "private_subnet_cidrs" {
  description = "The IDs of the public subnets created by this module."
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnet_cidrs" {
  description = "The IDs of the public subnets created by this module."
  value       = [for k, _ in local.sorted_azs : aws_subnet.public[k].cidr_block]
}
