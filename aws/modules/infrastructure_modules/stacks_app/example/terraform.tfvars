# Common configuration
env            =  "dev"

# Dynamo-DB
enable_dynamodb = true
table_name      = "menu"
hash_key        = "ID"
attribute_name  = "ID"
attribute_type  = "S"

# SQS
enable_queue = true
queue_name = "menu"

# Tags
tags = {
  Owner = "terraform"
  Name  = "Amido-Stacks"
}
