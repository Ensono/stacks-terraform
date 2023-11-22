# ECR Private Repositories
module "ecr" {
  for_each = toset(concat(var.repositories, flatten([for k, v in var.pull_through_cache_setup : [for v in v.images : "${k}/${v}"]])))

  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  create_repository = true

  repository_name                   = each.value
  repository_image_tag_mutability   = var.repository_image_tag_mutability
  repository_read_access_arns       = var.pull_accounts
  repository_read_write_access_arns = var.pull_and_push_accounts

  # Managed below in `ecr_registry_scanning_rules`
  manage_registry_scanning_configuration = false

  repository_lifecycle_policy = jsonencode({
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

## Pull Through Cache
data "aws_iam_policy_document" "pull_through_allow_pull" {
  dynamic "statement" {
    for_each = var.pull_through_cache_setup

    content {
      sid = "ElasticContainerRegistryPullThroughAllowRemotePull-${statement.key}"

      effect = "Allow"

      principals {
        identifiers = try(length(statement.value.accounts), 0) > 0 ? statement.value.accounts : local.pull_through_cache_accounts
        type        = "AWS"
      }

      actions = [
        "ecr:BatchImportUpstreamImage",
      ]

      resources = [
        "arn:aws:ecr:${var.region}:${data.aws_caller_identity.this.id}:repository/${statement.key}/*"
      ]
    }
  }
}

module "ecr_pull_through_cache" {
  count = length(var.pull_through_cache_setup) > 0 ? 1 : 0

  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  create_repository = false

  create_registry_policy = true
  registry_policy        = data.aws_iam_policy_document.pull_through_allow_pull.json

  registry_pull_through_cache_rules = { for k, v in var.pull_through_cache_setup :
    k => {
      ecr_repository_prefix = k,
      upstream_registry_url = v.upstream_registry_url
    }
  }
}

## ECR Registry Scanning Rules
module "ecr_registry_scanning_rules" {
  count = var.enable_registry_scanning ? 1 : 0

  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  create_repository = false

  manage_registry_scanning_configuration = true

  registry_scan_rules = [
    {
      scan_frequency = "CONTINUOUS_SCAN"
      filter         = "*"
      filter_type    = "WILDCARD"
    }
  ]
}
