## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.11.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_queue"></a> [app\_queue](#module\_app\_queue) | terraform-aws-modules/sqs/aws | ~> 2.0 |
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | terraform-aws-modules/dynamodb-table/aws | ~> 1.2 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attribute_name"></a> [attribute\_name](#input\_attribute\_name) | Name of the attribute. | `string` | n/a | yes |
| <a name="input_attribute_type"></a> [attribute\_type](#input\_attribute\_type) | Type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data. | `any` | n/a | yes |
| <a name="input_enable_dynamodb"></a> [enable\_dynamodb](#input\_enable\_dynamodb) | Whether to create dynamodb table. | `number` | `0` | no |
| <a name="input_enable_queue"></a> [enable\_queue](#input\_enable\_queue) | Whether to create SQS queue. | `bool` | `false` | no |
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
