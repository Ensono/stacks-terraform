##########
# DynamoDB
##########
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 1.2"

  count    = var.enable_dynamodb ? 1 : 0
  name     = var.table_name
  hash_key = var.hash_key

  attributes = [
    {
      name = var.attribute_name
      type = var.attribute_type
    }
  ]

  tags = var.tags
}

#####
# SQS
#####
module "queue" {
  source = "../../resource_modules/application_integration/sqs"

  create = var.enable_queue
  name   = var.queue_name
  tags   = var.tags
}
module "topic" {
  source = "../../resource_modules/application_integration/sns"

  create = var.enable_queue
  name   = var.queue_name
  tags   = var.tags

  create_sqs_subscription    = true
  subscription_sqs_queue_arn = module.queue.sqs_queue_arn
}
