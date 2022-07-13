############
# SNS TODO: Tactical, needs to be incorporated into app module
############
output "sns_topic_arn" {
  description = "The ARN for the created Amazon SNS topic"
  value       = var.enable_queue ? aws_sns_topic.main[0].arn : null
}
