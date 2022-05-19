# Label configuration
stage                   = "test"
name_company            = "amido"
name_project            = "stacks-cycle-8"
name_domain             = "netcore-api-cqrs"
resource_group_location = "eu-west-2"

# Dynamo-DB Configuration
enable_dynamodb = true
table_name      = "menu"
hash_key        = "ID"
attribute_name  = "ID"
attribute_type  = "S"

# SQS Configuration
enable_queue = true
queue_name   = "menu"

# Tags 
tags = {
  Owner = "terraform"
}
