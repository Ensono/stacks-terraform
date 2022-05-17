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
############
# SQS
############
 output "sqs_queue_id" {
   description = "The URL for the created Amazon SQS queue"
   value = var.enable_queue ? module.server_side_app.sqs_queue_id : null
 }

 output "sqs_queue_arn" {
   description = "The ARN of the SQS queue"
   value = var.enable_queue ? module.server_side_app.sqs_queue_arn : null
 }
 