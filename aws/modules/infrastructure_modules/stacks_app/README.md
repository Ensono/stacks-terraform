# AWS Stacks App

## Requirements

| Name                                                   | Version   |
| ------------------------------------------------------ | --------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 4.11.0 |

## Providers

No providers.

## Modules

| Name                                                                          | Source                                             | Version |
| ----------------------------------------------------------------------------- | -------------------------------------------------- | ------- |
| <a name="module_dynamodb_table"></a> [dynamodb_table](#module_dynamodb_table) | terraform-aws-modules/dynamodb-table/aws           | ~> 1.2  |
| <a name="module_queue"></a> [queue](#module_queue)                            | ../../resource_modules/application_integration/sqs | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                           | Description                                                                                             | Type          | Default | Required |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------- | ------------- | ------- | :------: |
| <a name="input_attribute_name"></a> [attribute_name](#input_attribute_name)    | Name of the attribute.                                                                                  | `string`      | n/a     |   yes    |
| <a name="input_attribute_type"></a> [attribute_type](#input_attribute_type)    | Type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data. | `any`         | n/a     |   yes    |
| <a name="input_enable_dynamodb"></a> [enable_dynamodb](#input_enable_dynamodb) | Whether to create dynamodb table.                                                                       | `bool`        | `false` |    no    |
| <a name="input_enable_queue"></a> [enable_queue](#input_enable_queue)          | Whether to create SQS queue.                                                                            | `bool`        | `false` |    no    |
| <a name="input_hash_key"></a> [hash_key](#input_hash_key)                      | The attribute to use as the hash (partition) key.                                                       | `string`      | n/a     |   yes    |
| <a name="input_queue_name"></a> [queue_name](#input_queue_name)                | This is the human-readable name of the queue. If omitted, Terraform will assign a random name.          | `string`      | n/a     |   yes    |
| <a name="input_table_name"></a> [table_name](#input_table_name)                | The name of the table, this needs to be unique within a region.                                         | `string`      | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                  | Meta data for labelling the infrastructure.                                                             | `map(string)` | n/a     |   yes    |

## Outputs

| Name                                                                                      | Description                              |
| ----------------------------------------------------------------------------------------- | ---------------------------------------- |
| <a name="output_dynamodb_table_arn"></a> [dynamodb_table_arn](#output_dynamodb_table_arn) | ARN of the DynamoDB table                |
| <a name="output_dynamodb_table_id"></a> [dynamodb_table_id](#output_dynamodb_table_id)    | ID of the DynamoDB table                 |
| <a name="output_sqs_queue_arn"></a> [sqs_queue_arn](#output_sqs_queue_arn)                | The ARN of the SQS queue                 |
| <a name="output_sqs_queue_id"></a> [sqs_queue_id](#output_sqs_queue_id)                   | The URL for the created Amazon SQS queue |
