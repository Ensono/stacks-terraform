# Current account ID
data "aws_caller_identity" "this" {}

data "aws_availability_zones" "available" {}

locals {

  trusted_key_identities = var.trusted_role_arn == "" ? ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"] : ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root", "${var.trusted_role_arn}"]
}

## EKS
data "aws_iam_policy_document" "eks_secret_encryption_kms_key_policy" {
  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.trusted_key_identities
    }

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.trusted_key_identities
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.trusted_key_identities
    }

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}
