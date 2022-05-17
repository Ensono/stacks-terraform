provider "aws" {
}

module "server_side_app" {

  source = "../"

  enable_dynamodb = var.enable_dynamodb
  table_name      = "${var.table_name}"
  hash_key        = var.hash_key
  attribute_name  = var.attribute_name
  attribute_type  = var.attribute_type
  enable_queue    = var.enable_queue
  queue_name      = var.queue_name
  env             = var.env
  tags            = var.tags
}
