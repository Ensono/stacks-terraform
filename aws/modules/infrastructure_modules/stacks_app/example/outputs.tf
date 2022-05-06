############
# Dynamo DB
############
output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = var.enable_dynamodb ? module.server_side_app.dynamodb_table_arn : null
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = var.enable_dynamodb ? module.server_side_app.dynamodb_table_id : null
}
