locals {
  pull_through_cache_accounts = length(var.pull_through_cache_accounts) > 0 ? var.pull_through_cache_accounts : ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
}
