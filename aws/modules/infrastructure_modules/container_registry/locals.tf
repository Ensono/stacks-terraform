locals {
  pull_through_cache_accounts = length(var.pull_through_cache_accounts) > 0 ? var.pull_through_cache_accounts : ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]

  # Always first, untagged cleanup
  untagged_rule = {
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
  }

  # Custom rules injected in the middle, priorities 2..N+1
  additional_rules_with_priority = [
    for idx, rule in var.additional_lifecycle_rules : merge(rule, {
      # Starts at 2, after untagged rule
      rulePriority = idx + 2
    })
  ]

  # Catch-all tagged rule - always last, priority N+2
  tagged_catch_all_rule = {
    rulePriority = length(var.additional_lifecycle_rules) + 2
    description  = "Keep the last '${var.max_tagged_image_count}' tagged images"
    selection = {
      tagStatus   = "any"
      countType   = "imageCountMoreThan"
      countNumber = var.max_tagged_image_count
    }
    action = { type = "expire" }
  }

  repository_lifecycle_policy = jsonencode({
    rules = concat(
      [local.untagged_rule],
      local.additional_rules_with_priority,
      [local.tagged_catch_all_rule]
    )
  })
}
