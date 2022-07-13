############
# SNS TODO: Tactical, needs to be incorporated into app module
############
output "sns_topic_arn" {
  description = "The ARN for the created Amazon SNS topic"
  value       = var.create ? aws_sns_topic_subscription.main[0].arn : null
}
