# DynamoDB
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 1.2"

  count    = var.enable_dynamodb
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
