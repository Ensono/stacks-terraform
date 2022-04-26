enable_zone     = true
enable_dynamodb = true

# DNS
public_zones = {
  "test.amido.com" = {
    comment = "This is a sample hosted zone don't use in production or any deployment purpose"
  }
}

# Dynamo-DB
table_name     = "amido"
hash_key       = "ID"
attribute_name = "ID"
attribute_type = "S"

# Tags
tags = {
  Owner = "terraform"
  Name  = "Amido-Stacks"
}
