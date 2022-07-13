#########
# Outputs
#########
output "sqs_queue_id" {
  description = "The ID for the created Amazon SQS Queue"
  value       = var.create ? aws_sqs_queue.queue[0].id : null
}
output "sqs_queue_arn" {
  description = "The ARN for the created Amazon SQS Queue"
  value       = var.create ? aws_sqs_queue.queue[0].arn : null
}
