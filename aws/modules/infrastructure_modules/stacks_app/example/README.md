## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_server_side_app"></a> [server\_side\_app](#module\_server\_side\_app) | ../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attribute_name"></a> [attribute\_name](#input\_attribute\_name) | Name of the attribute. | `string` | n/a | yes |
| <a name="input_attribute_type"></a> [attribute\_type](#input\_attribute\_type) | Type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data. | `any` | n/a | yes |
| <a name="input_enable_dynamodb"></a> [enable\_dynamodb](#input\_enable\_dynamodb) | Whether to create dynamodb table. | `bool` | n/a | yes |
| <a name="input_enable_queue"></a> [enable\_queue](#input\_enable\_queue) | Whether to create SQS queue. | `bool` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Name of the deployment environment, like dev, staging, nonprod, prod. | `string` | n/a | yes |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. | `string` | n/a | yes |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | This is the human-readable name of the queue. If omitted, Terraform will assign a random name. | `string` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | The name of the table, this needs to be unique within a region. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Meta data for labelling the infrastructure. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | ID of the DynamoDB table |
