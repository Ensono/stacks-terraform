############
# SNS
############
output "sns_topic_arn" {
  description = "The ARN for the created Amazon SNS topic"
  value = element(
    concat(
      aws_sns_topic_subscription.main.*.arn,
      [""],
    ),
    0,
  )
}
