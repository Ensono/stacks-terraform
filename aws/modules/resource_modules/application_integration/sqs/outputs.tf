#########
# Outputs
#########
output "sqs_queue_id" {
  count       = var.create ? 1 : 0
  description = "The ARN for the created Amazon SNS topic"
  value       = var.create ? aws_sqs_queue.queue[0].id : null
}
output "sqs_queue_arn" {
  count       = var.create ? 1 : 0
  description = "The ARN for the created Amazon SNS topic"
  value       = var.create ? aws_sqs_queue.queue[0].arn : null
}
