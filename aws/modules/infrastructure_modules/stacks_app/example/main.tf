provider "aws" {
}

resource "random_string" "random" {
  length  = 3
  special = false
}

module "server_side_app" {

  source = "../"

  enable_zone     = var.enable_zone ? 1 : 0
  enable_dynamodb = var.enable_dynamodb ? 1 : 0
  public_zones    = var.public_zones


  table_name     = "${var.table_name}-${random_string.random.result}"
  hash_key       = var.hash_key
  attribute_name = var.attribute_name
  attribute_type = var.attribute_type
  tags           = var.tags
}
