## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_solution.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_client_config.spn_client](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_insights_name"></a> [app\_insights\_name](#input\_app\_insights\_name) | Name of the App Insights Instance to be created. | `string` | `""` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes for tagging | `list` | `[]` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key Vault name - if not specificied will default to computed naming convention | `string` | `""` | no |
| <a name="input_la_name"></a> [la\_name](#input\_la\_name) | Name of the Log Analtics Instance to be created. | `string` | `""` | no |
| <a name="input_log_application_type"></a> [log\_application\_type](#input\_log\_application\_type) | Log application type | `string` | `"other"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the RG | `string` | `"useast"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Data Platform Resource Group. | `string` | `""` | no |
| <a name="input_resource_group_tags"></a> [resource\_group\_tags](#input\_resource\_group\_tags) | Tags at a RG level | `map(string)` | `{}` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | n/a | `number` | `30` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | n/a | `string` | `"dev"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be assigned to all resources, NB if global tagging is enabled these will get overwritten periodically | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_insights_id"></a> [app\_insights\_id](#output\_app\_insights\_id) | n/a |
| <a name="output_app_insights_key"></a> [app\_insights\_key](#output\_app\_insights\_key) | n/a |
| <a name="output_app_insights_name"></a> [app\_insights\_name](#output\_app\_insights\_name) | n/a |
| <a name="output_app_insights_resource_group_name"></a> [app\_insights\_resource\_group\_name](#output\_app\_insights\_resource\_group\_name) | n/a |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | n/a |