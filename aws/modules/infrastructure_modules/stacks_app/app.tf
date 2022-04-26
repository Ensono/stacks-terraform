# Create DNS Zones
module "zones" {

  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"
  count   = var.enable_zone
  zones   = var.public_zones
  tags    = var.tags
}


# Create DynamoDB
module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
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