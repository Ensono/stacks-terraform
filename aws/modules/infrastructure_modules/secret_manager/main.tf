resource "aws_secretsmanager_secret" "sec" {
  count                   = length(local.secrets)
  name                    = lookup(element(local.secrets, count.index), "name")
  description             = lookup(element(local.secrets, count.index), "description")
  kms_key_id              = lookup(element(local.secrets, count.index), "kms_key_id")
  policy                  = lookup(element(local.secrets, count.index), "policy")
  recovery_window_in_days = lookup(element(local.secrets, count.index), "recovery_window_in_days")
  # Tags
  tags = merge(var.tags, lookup(element(local.secrets, count.index), "tags"))
}

resource "aws_secretsmanager_secret_version" "secver" {
  count         = var.unmanaged ? length(local.secrets) : 0
  secret_id     = aws_secretsmanager_secret.sec.*.id[count.index]
  secret_string = lookup(element(local.secrets, count.index), "secret_value")
  depends_on    = [aws_secretsmanager_secret.sec]
}

locals {
  secrets = [
    for secret in var.secrets : {
      name                    = lookup(secret, "name", null)
      description             = lookup(secret, "description", null)
      kms_key_id              = lookup(secret, "kms_key_id", null)
      policy                  = lookup(secret, "policy", null)
      recovery_window_in_days = lookup(secret, "recovery_window_in_days", var.recovery_window_in_days)
      secret_string           = lookup(secret, "secret_string", null) != null ? lookup(secret, "secret_string") : (lookup(secret, "secret_key_value", null) != null ? jsonencode(lookup(secret, "secret_key_value", {})) : null)
      tags                    = lookup(secret, "tags", {})
    }
  ]
}
