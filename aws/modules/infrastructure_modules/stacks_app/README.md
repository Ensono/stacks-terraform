## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.11.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | terraform-aws-modules/dynamodb-table/aws | n/a |
| <a name="module_zones"></a> [zones](#module\_zones) | terraform-aws-modules/route53/aws//modules/zones | ~> 2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attribute_name"></a> [attribute\_name](#input\_attribute\_name) | Name of the attribute. | `string` | n/a | yes |
| <a name="input_attribute_type"></a> [attribute\_type](#input\_attribute\_type) | Type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data | `any` | n/a | yes |
| <a name="input_enable_dynamodb"></a> [enable\_dynamodb](#input\_enable\_dynamodb) | Conditionally create dynamodb | `number` | n/a | yes |
| <a name="input_enable_zone"></a> [enable\_zone](#input\_enable\_zone) | Conditionally create route53 zones | `number` | n/a | yes |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. | `string` | n/a | yes |
| <a name="input_public_zones"></a> [public\_zones](#input\_public\_zones) | Map of Route53 zone parameters | `map(any)` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | The name of the table, this needs to be unique within a region. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Meta data for labelling the infrastructure | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | ID of the DynamoDB table |
| <a name="output_route53_zone_name"></a> [route53\_zone\_name](#output\_route53\_zone\_name) | Name of Route53 zone |
| <a name="output_route53_zone_name_servers"></a> [route53\_zone\_name\_servers](#output\_route53\_zone\_name\_servers) | Name servers of Route53 zone |
| <a name="output_route53_zone_zone_id"></a> [route53\_zone\_zone\_id](#output\_route53\_zone\_zone\_id) | Zone ID of Route53 zone |
