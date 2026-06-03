# Provision an IRSA

Terraform configuration files to create remote backend end with locking mechanism.

<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)          | n/a     |
| <a name="provider_random"></a> [random](#provider_random) | n/a     |

## Modules

| Name                                                                                                                                      | Source                                   | Version |
| ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ------- |
| <a name="module_dynamodb_terraform_state_lock"></a> [dynamodb_terraform_state_lock](#module_dynamodb_terraform_state_lock)                | ../../resource_modules/database/dynamodb | n/a     |
| <a name="module_s3_bucket_terraform_remote_backend"></a> [s3_bucket_terraform_remote_backend](#module_s3_bucket_terraform_remote_backend) | ../../resource_modules/storage/s3        | n/a     |
| <a name="module_s3_kms_key_terraform_backend"></a> [s3_kms_key_terraform_backend](#module_s3_kms_key_terraform_backend)                   | ../../resource_modules/identity/kms_key  | n/a     |

## Resources

| Name                                                                                                                                                             | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [random_integer.digits](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer)                                                  | resource    |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                       | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                      | data source |
| [aws_iam_policy_document.s3_terraform_states_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name                                                                                                   | Description                                                                                                                                                                                                                                                                               | Type       | Default | Required |
| ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------- | :------: |
| <a name="input_acl"></a> [acl](#input_acl)                                                             | The canned ACL to apply.                                                                                                                                                                                                                                                                  | `string`   | n/a     |   yes    |
| <a name="input_app_name"></a> [app_name](#input_app_name)                                              | The name of the application.                                                                                                                                                                                                                                                              | `string`   | n/a     |   yes    |
| <a name="input_attribute_name"></a> [attribute_name](#input_attribute_name)                            | n/a                                                                                                                                                                                                                                                                                       | `any`      | n/a     |   yes    |
| <a name="input_attribute_type"></a> [attribute_type](#input_attribute_type)                            | n/a                                                                                                                                                                                                                                                                                       | `any`      | n/a     |   yes    |
| <a name="input_block_public_acls"></a> [block_public_acls](#input_block_public_acls)                   | Whether Amazon S3 should ignore public ACLs for this bucket.                                                                                                                                                                                                                              | `string`   | n/a     |   yes    |
| <a name="input_block_public_policy"></a> [block_public_policy](#input_block_public_policy)             | Whether Amazon S3 should block public bucket policies for this bucket.                                                                                                                                                                                                                    | `string`   | n/a     |   yes    |
| <a name="input_env"></a> [env](#input_env)                                                             | The name of the environment.                                                                                                                                                                                                                                                              | `string`   | n/a     |   yes    |
| <a name="input_force_destroy"></a> [force_destroy](#input_force_destroy)                               | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable.                                                                                                                              | `string`   | n/a     |   yes    |
| <a name="input_hash_key"></a> [hash_key](#input_hash_key)                                              | The attribute to use as the hash (partition) key.                                                                                                                                                                                                                                         | `string`   | n/a     |   yes    |
| <a name="input_ignore_public_acls"></a> [ignore_public_acls](#input_ignore_public_acls)                | Whether Amazon S3 should ignore public ACLs for this bucket.                                                                                                                                                                                                                              | `string`   | n/a     |   yes    |
| <a name="input_read_capacity"></a> [read_capacity](#input_read_capacity)                               | The number of read units for this table.                                                                                                                                                                                                                                                  | `string`   | n/a     |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                    | The AWS region this bucket should reside in.                                                                                                                                                                                                                                              | `string`   | n/a     |   yes    |
| <a name="input_restrict_public_buckets"></a> [restrict_public_buckets](#input_restrict_public_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket.                                                                                                                                                                                                                 | `string`   | n/a     |   yes    |
| <a name="input_sse_enabled"></a> [sse_enabled](#input_sse_enabled)                                     | Encryption at rest using an AWS managed Customer Master Key. If enabled is false then server-side encryption is set to AWS owned CMK (shown as DEFAULT in the AWS console). If enabled is true then server-side encryption is set to AWS managed CMK (shown as KMS in the AWS console). . | `string`   | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                          | A mapping of tags to assign to the resources.                                                                                                                                                                                                                                             | `map(any)` | n/a     |   yes    |
| <a name="input_versioning_enabled"></a> [versioning_enabled](#input_versioning_enabled)                | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state.                                                                                                                                                                                         | `string`   | n/a     |   yes    |
| <a name="input_write_capacity"></a> [write_capacity](#input_write_capacity)                            | The number of write units for this table.                                                                                                                                                                                                                                                 | `string`   | n/a     |   yes    |

## Outputs

| Name                                                                                | Description                                      |
| ----------------------------------------------------------------------------------- | ------------------------------------------------ |
| <a name="output_dynamodb_arn"></a> [dynamodb_arn](#output_dynamodb_arn)             | The arn of the table                             |
| <a name="output_dynamodb_id"></a> [dynamodb_id](#output_dynamodb_id)                | The name of the table                            |
| <a name="output_s3_arn"></a> [s3_arn](#output_s3_arn)                               | The arn of the table                             |
| <a name="output_s3_id"></a> [s3_id](#output_s3_id)                                  | The name of the table                            |
| <a name="output_s3_kms_alias_arn"></a> [s3_kms_alias_arn](#output_s3_kms_alias_arn) | The Amazon Resource Name (ARN) of the key alias. |
| <a name="output_s3_kms_arn"></a> [s3_kms_arn](#output_s3_kms_arn)                   | The Amazon Resource Name (ARN) of the key.       |
| <a name="output_s3_kms_id"></a> [s3_kms_id](#output_s3_kms_id)                      | The globally unique identifier for the key.      |

<!-- END_TF_DOCS -->
