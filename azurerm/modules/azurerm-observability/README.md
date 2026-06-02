# Azure Observability

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)       | ~> 3.0  |

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~> 3.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                               | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [azurerm_application_insights.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights)       | resource    |
| [azurerm_log_analytics_solution.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution)   | resource    |
| [azurerm_log_analytics_workspace.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource    |
| [azurerm_client_config.spn_client](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)               | data source |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)                | data source |

## Inputs

| Name                                                                                                   | Description                                                                                                   | Type          | Default    | Required |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | ------------- | ---------- | :------: |
| <a name="input_app_insights_name"></a> [app_insights_name](#input_app_insights_name)                   | Name of the App Insights Instance to be created.                                                              | `string`      | `""`       |    no    |
| <a name="input_attributes"></a> [attributes](#input_attributes)                                        | Additional attributes for tagging                                                                             | `list`        | `[]`       |    no    |
| <a name="input_key_vault_name"></a> [key_vault_name](#input_key_vault_name)                            | Key Vault name - if not specificied will default to computed naming convention                                | `string`      | `""`       |    no    |
| <a name="input_la_name"></a> [la_name](#input_la_name)                                                 | Name of the Log Analtics Instance to be created.                                                              | `string`      | `""`       |    no    |
| <a name="input_log_application_type"></a> [log_application_type](#input_log_application_type)          | Log application type                                                                                          | `string`      | `"other"`  |    no    |
| <a name="input_resource_group_location"></a> [resource_group_location](#input_resource_group_location) | Location of the RG                                                                                            | `string`      | `"useast"` |    no    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)             | Name of the Data Platform Resource Group.                                                                     | `string`      | `""`       |    no    |
| <a name="input_resource_group_tags"></a> [resource_group_tags](#input_resource_group_tags)             | Tags at a RG level                                                                                            | `map(string)` | `{}`       |    no    |
| <a name="input_retention_in_days"></a> [retention_in_days](#input_retention_in_days)                   | n/a                                                                                                           | `number`      | `30`       |    no    |
| <a name="input_stage"></a> [stage](#input_stage)                                                       | n/a                                                                                                           | `string`      | `"dev"`    |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                          | Tags to be assigned to all resources, NB if global tagging is enabled these will get overwritten periodically | `map(string)` | `{}`       |    no    |

## Outputs

| Name                                                                                                                                | Description |
| ----------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_app_insights_id"></a> [app_insights_id](#output_app_insights_id)                                                    | n/a         |
| <a name="output_app_insights_key"></a> [app_insights_key](#output_app_insights_key)                                                 | n/a         |
| <a name="output_app_insights_name"></a> [app_insights_name](#output_app_insights_name)                                              | n/a         |
| <a name="output_app_insights_resource_group_name"></a> [app_insights_resource_group_name](#output_app_insights_resource_group_name) | n/a         |
| <a name="output_log_analytics_workspace_id"></a> [log_analytics_workspace_id](#output_log_analytics_workspace_id)                   | n/a         |
