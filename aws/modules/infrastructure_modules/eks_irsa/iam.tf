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
}

resource "aws_iam_role" "role" {
  name               = local.iam_full_name
  path               = local.iam_path
  description        = "Role for ${var.resource_description}"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_iam_policy" "policy" {
  name        = local.iam_full_name
  path        = local.iam_path
  description = "Policy for ${var.resource_description}"
  policy      = var.policy
}

resource "aws_iam_role_policy_attachment" "attach" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}
