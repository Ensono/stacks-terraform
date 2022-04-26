
provider "aws" {
}

resource "random_pet" "this" {
  length = 2
}

module "server_side_app" {

  source = "../"

  enable_zone     = 1
  enable_dynamodb = 0
  public_zones = {
    "example.com" = {
      comment = "testing modules"
    }
  }
  table_name     = "my-table-${random_pet.this.id}"
  hash_key       = "ID"
  attribute_name = "ID"
  attribute_type = "S"
  tags = {
    Owner = "terraform"
    Name  = "Amido-Stacks"
  }
}