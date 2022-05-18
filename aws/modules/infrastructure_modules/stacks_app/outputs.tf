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
#####
# SQS
#####
output "sqs_queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = length(module.queue) > 0 ? module.queue[*].sqs_queue_id : null
}

output "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
  value       = length(module.queue) > 0 ? module.queue[*].sqs_queue_arn : null
}
