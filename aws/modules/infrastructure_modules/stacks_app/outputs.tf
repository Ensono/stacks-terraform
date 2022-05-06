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
