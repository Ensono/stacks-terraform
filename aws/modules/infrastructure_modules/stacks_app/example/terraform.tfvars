# Common configuration
env            =  "dev"

# Dynamo-DB
enable_dynamodb = true
table_name      = "Menu"
hash_key        = "ID"
attribute_name  = "ID"
attribute_type  = "S"

# SQS
enable_queue = true
queue_name = "Menu"

# Tags
tags = {
  Owner = "terraform"
  Name  = "Amido-Stacks"
}
