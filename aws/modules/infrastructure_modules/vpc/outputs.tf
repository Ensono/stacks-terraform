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
