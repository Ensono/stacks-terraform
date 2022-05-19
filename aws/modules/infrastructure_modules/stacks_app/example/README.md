## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.37.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app"></a> [app](#module\_app) | ../ | n/a |
| <a name="module_app_label"></a> [app\_label](#module\_app\_label) | cloudposse/label/null | 0.25.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attribute_name"></a> [attribute\_name](#input\_attribute\_name) | Name of the attribute. | `string` | n/a | yes |
| <a name="input_attribute_type"></a> [attribute\_type](#input\_attribute\_type) | Type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data. | `any` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. List of attributes. | `list` | `[]` | no |
| <a name="input_enable_dynamodb"></a> [enable\_dynamodb](#input\_enable\_dynamodb) | Whether to create dynamodb table. | `bool` | `false` | no |
| <a name="input_enable_queue"></a> [enable\_queue](#input\_enable\_queue) | Whether to create SQS queue. | `bool` | `false` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. | `string` | n/a | yes |
| <a name="input_location_name_map"></a> [location\_name\_map](#input\_location\_name\_map) | Each region must have corresponding a shortend name for resource naming purposes. | `map(string)` | <pre>{<br>  "ap-northeast-1": "apne1",<br>  "ap-northeast-2": "apne2",<br>  "ap-south-1": "aps1",<br>  "ap-southeast-1": "apse1",<br>  "ap-southeast-2": "apse2",<br>  "cn-north-1": "cnn1",<br>  "eu-central-1": "euc1",<br>  "eu-north-1": "eun1",<br>  "eu-south-1": "eus1",<br>  "eu-west-1": "euw1",<br>  "eu-west-2": "euw2",<br>  "eu-west-3": "euw3",<br>  "sa-east-1": "sae1",<br>  "us-east-1": "use1",<br>  "us-east-2": "use2",<br>  "us-west-1": "usw1",<br>  "us-west-2": "usw2"<br>}</pre> | no |
| <a name="input_name_company"></a> [name\_company](#input\_name\_company) | ID element. Usually used to indicate specific organisation. | `string` | n/a | yes |
| <a name="input_name_domain"></a> [name\_domain](#input\_name\_domain) | ID element. Usually used to indicate specific API. | `string` | n/a | yes |
| <a name="input_name_project"></a> [name\_project](#input\_name\_project) | ID element. Usually used to indicate specific project. | `string` | n/a | yes |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | This is the human-readable name of the queue. If omitted, Terraform will assign a random name. | `string` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | AWS region-code corresponding to aws infrastrcuture deployed, example for london it should be eu-west-2. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging','test', 'deploy', 'release'. | `string` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | The name of the table, this needs to be unique within a region. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Meta data for labelling the infrastructure. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | ID of the DynamoDB table |
| <a name="output_sqs_queue_arn"></a> [sqs\_queue\_arn](#output\_sqs\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_sqs_queue_id"></a> [sqs\_queue\_id](#output\_sqs\_queue\_id) | The URL for the created Amazon SQS queue |
