# TODO: Check why this key is so wide open...
data "aws_iam_policy_document" "logging_bucket_secret_encryption_kms_key_policy" {
  count = var.flow_log_enabled ? 1 : 0

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
      ]
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
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
      ]
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
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
      ]
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

module "logging_bucket_kms_key" {
  count = var.flow_log_enabled ? 1 : 0

  source = "../../resource_modules/identity/kms_key"

  name                    = local.logging_bucket_kms_key_name
  description             = local.logging_bucket_kms_key_description
  deletion_window_in_days = local.logging_bucket_kms_key_deletion_window_in_days
  tags                    = local.logging_bucket_kms_key_tags
  policy                  = data.aws_iam_policy_document.logging_bucket_secret_encryption_kms_key_policy.0.json
  enable_key_rotation     = true
}

data "aws_iam_policy_document" "logging_bucket_policy" {
  count = var.flow_log_enabled ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }

    actions = [
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]

    resources = [
      module.logging_bucket.0.s3_bucket_arn,
    ]
  }

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    resources = [
      "${module.logging_bucket.0.s3_bucket_arn}/*",
    ]
  }
}

module "logging_bucket" {
  count = var.flow_log_enabled ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.4.0"

  bucket                                = local.logging_bucket_name
  acl                                   = "private"
  policy                                = data.aws_iam_policy_document.logging_bucket_policy.0.json
  attach_policy                         = true
  attach_deny_insecure_transport_policy = true
  block_public_acls                     = true
  block_public_policy                   = true
  ignore_public_acls                    = true
  restrict_public_buckets               = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.logging_bucket_kms_key.0.arn
      }
    }
  }
}

module "vpc_flow_logs" {
  count = var.flow_log_enabled ? 1 : 0

  source  = "cloudposse/vpc-flow-logs-s3-bucket/aws"
  version = "1.3.1"

  name = "${var.vpc_name}-vpc-flow-logs"

  lifecycle_configuration_rules = [
    {
      enabled                                = true
      id                                     = "lifecycle-policy"
      abort_incomplete_multipart_upload_days = 5

      transition = [
        {
          days          = var.flow_log_standard_transition_days
          storage_class = "STANDARD_IA"
        },
        {
          days          = var.flow_log_glacier_transition_days
          storage_class = "GLACIER"
        }
      ]

      noncurrent_version_transition = [
        {
          noncurrent_days = var.flow_log_noncurrent_version_transition_days
          storage_class   = "GLACIER"
        }
      ]

      noncurrent_version_expiration = {
        noncurrent_days = var.flow_log_noncurrent_version_expiry_days
      }

      expiration = {
        days = var.flow_log_expiry_days
      }
    }
  ]

  force_destroy           = var.flow_log_force_destroy
  allow_ssl_requests_only = var.flow_log_allow_ssl_requests_only
  vpc_id                  = module.vpc.vpc_id

  access_log_bucket_name       = module.logging_bucket.0.s3_bucket_id
  access_log_bucket_prefix     = "bucket_access_logs/"
  bucket_notifications_enabled = true

  tags = var.tags
}
