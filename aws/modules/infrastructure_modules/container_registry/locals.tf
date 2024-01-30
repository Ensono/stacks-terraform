locals {
  pull_through_cache_accounts = length(var.pull_through_cache_accounts) > 0 ? var.pull_through_cache_accounts : ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]

  repository_lifecycle_default_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep the last '${var.max_untagged_image_count}' untagged images"

        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.max_untagged_image_count
        }

        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2,
        description  = "Keep the last '${var.max_tagged_image_count}' tagged images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_tagged_image_count
        }

        action = {
          type = "expire"
        }
      },
    ]
  })
}
