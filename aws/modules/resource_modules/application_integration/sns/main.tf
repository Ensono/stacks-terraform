###################
# AWS SNS resource
###################

resource "aws_sns_topic" "main" {
  count = var.create ? 1 : 0
  name  = var.name
  tags  = var.tags
}

resource "aws_sns_topic_subscription" "main" {
  count     = var.create_sqs_subscription ? 1 : 0
  topic_arn = aws_sns_topic.main[0].arn
  protocol  = "sqs"
  endpoint  = var.subscription_sqs_queue_arn
}
