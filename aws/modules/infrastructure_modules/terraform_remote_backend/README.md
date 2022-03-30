# Provision an IRSA 


Terraform configuration files to create remote backend end with locking mechanism.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_terraform_state_lock"></a> [dynamodb\_terraform\_state\_lock](#module\_dynamodb\_terraform\_state\_lock) | ../../resource_modules/database/dynamodb | n/a |
| <a name="module_s3_bucket_terraform_remote_backend"></a> [s3\_bucket\_terraform\_remote\_backend](#module\_s3\_bucket\_terraform\_remote\_backend) | ../../resource_modules/storage/s3 | n/a |
| <a name="module_s3_kms_key_terraform_backend"></a> [s3\_kms\_key\_terraform\_backend](#module\_s3\_kms\_key\_terraform\_backend) | ../../resource_modules/identity/kms_key | n/a |

## Resources

| Name | Type |
|------|------|
| [random_integer.digits](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_terraform_states_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | The canned ACL to apply. | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the application. | `string` | n/a | yes |
| <a name="input_attribute_name"></a> [attribute\_name](#input\_attribute\_name) | n/a | `any` | n/a | yes |
| <a name="input_attribute_type"></a> [attribute\_type](#input\_attribute\_type) | n/a | `any` | n/a | yes |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `string` | n/a | yes |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The name of the environment. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `string` | n/a | yes |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. | `string` | n/a | yes |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `string` | n/a | yes |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | The number of read units for this table. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region this bucket should reside in. | `string` | n/a | yes |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `string` | n/a | yes |
| <a name="input_sse_enabled"></a> [sse\_enabled](#input\_sse\_enabled) | Encryption at rest using an AWS managed Customer Master Key. If enabled is false then server-side encryption is set to AWS owned CMK (shown as DEFAULT in the AWS console). If enabled is true then server-side encryption is set to AWS managed CMK (shown as KMS in the AWS console). . | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources. | `map(any)` | n/a | yes |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. | `string` | n/a | yes |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | The number of write units for this table. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_arn"></a> [dynamodb\_arn](#output\_dynamodb\_arn) | The arn of the table |
| <a name="output_dynamodb_id"></a> [dynamodb\_id](#output\_dynamodb\_id) | The name of the table |
| <a name="output_s3_arn"></a> [s3\_arn](#output\_s3\_arn) | The arn of the table |
| <a name="output_s3_id"></a> [s3\_id](#output\_s3\_id) | The name of the table |
| <a name="output_s3_kms_alias_arn"></a> [s3\_kms\_alias\_arn](#output\_s3\_kms\_alias\_arn) | The Amazon Resource Name (ARN) of the key alias. |
| <a name="output_s3_kms_arn"></a> [s3\_kms\_arn](#output\_s3\_kms\_arn) | The Amazon Resource Name (ARN) of the key. |
| <a name="output_s3_kms_id"></a> [s3\_kms\_id](#output\_s3\_kms\_id) | The globally unique identifier for the key. |
<!-- END_TF_DOCS -->