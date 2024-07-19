locals {
  sanitised_issuer_url = replace(var.cluster_oidc_issuer_url, "https://", "")
  iam_name             = "${var.namespace}-${var.service_account_name}"
  iam_path             = (var.policy_path != null) ? var.policy_path : "/${var.cluster_name}/"
  iam_full_name        = length(var.policy_prefix) > 0 ? "${var.policy_prefix}-${local.iam_name}" : local.iam_name
}

data "aws_iam_policy_document" "role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = ["arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.sanitised_issuer_url}"]
      type        = "Federated"
    }

    condition {
      test     = "StringEquals"
      variable = "${local.sanitised_issuer_url}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.sanitised_issuer_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.additional_service_account_names

    content {
      actions = ["sts:AssumeRoleWithWebIdentity"]
      effect  = "Allow"

      principals {
        identifiers = ["arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.sanitised_issuer_url}"]
        type        = "Federated"
      }

      condition {
        test     = "StringEquals"
        variable = "${local.sanitised_issuer_url}:sub"
        values   = ["system:serviceaccount:${var.namespace}:${each.value}"]
      }

      condition {
        test     = "StringEquals"
        variable = "${local.sanitised_issuer_url}:aud"
        values   = ["sts.amazonaws.com"]
      }
    }
  }
}

resource "aws_iam_role" "role" {
  name               = local.iam_full_name
  path               = local.iam_path
  description        = "Role for ${var.resource_description}"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_iam_policy" "policy" {
  count = length(var.policy) > 0 ? 1 : 0

  name        = local.iam_full_name
  path        = local.iam_path
  description = "Policy for ${var.resource_description}"
  policy      = var.policy
}

resource "aws_iam_role_policy_attachment" "attach" {
  count = length(var.policy) > 0 ? 1 : 0

  policy_arn = aws_iam_policy.policy.0.arn
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "additional_attach" {
  for_each = var.additional_policies

  policy_arn = data.aws_iam_policy.additional_policies[each.key].arn
  role       = aws_iam_role.role.name
}
