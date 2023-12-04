# TODO: Fix this when issue is answered: https://github.com/cloudposse/terraform-aws-vpc-flow-logs-s3-bucket/issues/66
# data "aws_iam_policy_document" "logging_bucket_secret_encryption_kms_key_policy" {
#   statement {
#     sid    = "Allow access for Key Administrators"
#     effect = "Allow"

#     principals {
#       type = "AWS"

#       identifiers = [
#         "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
#       ]
#     }

#     actions = [
#       "kms:Create*",
#       "kms:Describe*",
#       "kms:Enable*",
#       "kms:List*",
#       "kms:Put*",
#       "kms:Update*",
#       "kms:Revoke*",
#       "kms:Disable*",
#       "kms:Get*",
#       "kms:Delete*",
#       "kms:TagResource",
#       "kms:UntagResource",
#       "kms:ScheduleKeyDeletion",
#       "kms:CancelKeyDeletion",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     sid    = "Allow use of the key"
#     effect = "Allow"

#     principals {
#       type = "AWS"

#       identifiers = [
#         "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
#       ]
#     }

#     actions = [
#       "kms:Encrypt",
#       "kms:Decrypt",
#       "kms:ReEncrypt*",
#       "kms:GenerateDataKey*",
#       "kms:DescribeKey",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     sid    = "Allow attachment of persistent resources"
#     effect = "Allow"

#     principals {
#       type = "AWS"

#       identifiers = [
#         "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
#       ]
#     }

#     actions = [
#       "kms:CreateGrant",
#       "kms:ListGrants",
#       "kms:RevokeGrant",
#     ]

#     resources = ["*"]

#     condition {
#       test     = "Bool"
#       variable = "kms:GrantIsForAWSResource"
#       values   = ["true"]
#     }
#   }
# }


# module "logging_bucket_kms_key" {
#   source = "../../resource_modules/identity/kms_key"

#   name                    = local.logging_bucket_kms_key_name
#   description             = local.logging_bucket_kms_key_description
#   deletion_window_in_days = local.logging_bucket_kms_key_deletion_window_in_days
#   tags                    = local.logging_bucket_kms_key_tags
#   policy                  = data.aws_iam_policy_document.logging_bucket_secret_encryption_kms_key_policy.json
#   enable_key_rotation     = true
# }

# data "aws_iam_policy_document" "logging_bucket_policy" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
#     }

#     actions = [
#       "s3:ListBucket",
#       "s3:ListBucketMultipartUploads",
#     ]

#     resources = [
#       module.logging_bucket.s3_bucket_arn,
#     ]
#   }

#   statement {
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:PutObject",
#       "s3:PutObjectAcl",
#       "s3:AbortMultipartUpload",
#       "s3:ListMultipartUploadParts",
#     ]

#     resources = [
#       "${module.logging_bucket.s3_bucket_arn}/*",
#     ]
#   }
# }

# module "logging_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "3.15.1"

#   bucket                                = "${var.vpc_name}-logging-bucket"
#   acl                                   = "private"
#   policy                                = data.aws_iam_policy_document.logging_bucket_policy.json
#   attach_policy                         = true
#   attach_deny_insecure_transport_policy = true
#   block_public_acls                     = true
#   block_public_policy                   = true
#   ignore_public_acls                    = true
#   restrict_public_buckets               = true

#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         sse_algorithm     = "aws:kms"
#         kms_master_key_id = module.logging_bucket_kms_key.arn
#       }
#     }
#   }
# }

# module "vpc_flow_logs" {
#   source  = "cloudposse/vpc-flow-logs-s3-bucket/aws"
#   version = "1.0"

#   name = "${var.vpc_name}-vpc-flow-logs"

#   lifecycle_configuration_rules = [
#     {
#       enabled                                = true
#       id                                     = "lifecycle-policy"
#       abort_incomplete_multipart_upload_days = 5

#       transition = [
#         {
#           days          = var.flow_log_standard_transition_days
#           storage_class = "STANDARD_IA"
#         },
#         {
#           days          = var.flow_log_glacier_transition_days
#           storage_class = "GLACIER"
#         }
#       ]

#       noncurrent_version_transition = [
#         {
#           noncurrent_days = var.flow_log_noncurrent_version_transition_days
#           storage_class   = "GLACIER"
#         }
#       ]

#       noncurrent_version_expiration = {
#         noncurrent_days = var.flow_log_noncurrent_version_expiry_days
#       }

#       expiration = {
#         days = var.flow_log_expiry_days
#       }
#     }
#   ]

#   force_destroy           = var.flow_log_force_destroy
#   allow_ssl_requests_only = var.flow_log_allow_ssl_requests_only
#   vpc_id                  = module.vpc.vpc_id

#   access_log_bucket_name       = module.logging_bucket.s3_bucket_id
#   access_log_bucket_prefix     = "bucket_access_logs/"
#   bucket_notifications_enabled = true # Only supports SQS - it creates the Q within the module

#   tags = var.tags
# }
