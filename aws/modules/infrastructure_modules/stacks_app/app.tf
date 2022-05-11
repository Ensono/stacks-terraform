##########
# DynamoDB
##########
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 1.2"

  count    = var.enable_dynamodb ? 1 : 0
  name     = "${var.table_name}-${var.env}"
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
module "app_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"
  
  create  = var.enable_queue
  name    = "${var.queue_name}-${var.env}"
  tags    = var.tags
}
