<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.99.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | Specifies the GitHub account name. | `string` | `"amido"` | no |
| <a name="input_adf_idenity"></a> [adf\_idenity](#input\_adf\_idenity) | enable idenity block in module | `bool` | `true` | no |
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Specifies the branch of the repository to get code from | `string` | `"feature/test"` | no |
| <a name="input_create_adf"></a> [create\_adf](#input\_create\_adf) | set value wether to create a KV or not | `bool` | `true` | no |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | specifies the GitHub Enterprise host name. For example: https://github.mydomain.com. Use https://github.com for open source repositories. | `string` | `"https://github.com"` | no |
| <a name="input_github_enabled"></a> [github\_enabled](#input\_github\_enabled) | A github\_configuration block for ADF integration ? | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Data Factory. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned,UserAssigned (to enable both) | `string` | `"SystemAssigned"` | no |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | Is Managed Virtual Network enabled? | `bool` | `false` | no |
| <a name="input_name_component"></a> [name\_component](#input\_name\_component) | Component Name - should/will be used in conventional resource naming. Typically this will be a logical name for this part of the system i.e. `API` \|\| `middleware` or more generic like `Billing` | `string` | `"kv"` | no |
| <a name="input_public_network_enabled"></a> [public\_network\_enabled](#input\_public\_network\_enabled) | Is the Data Factory visible to the public network? Defaults to | `bool` | `true` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Specifies the name of the git repository | `string` | `"stacks"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of Resource group | `string` | `"uksouth"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of resource group | `string` | n/a | yes |
| <a name="input_resource_namer"></a> [resource\_namer](#input\_resource\_namer) | User defined naming convention applied to all resources created as part of this module | `string` | n/a | yes |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Map of tags to be applied to all resources created as part of this module | `map(string)` | `{}` | no |
| <a name="input_root_folder"></a> [root\_folder](#input\_root\_folder) | Specifies the root folder within the repository. Set to / for the top level. | `string` | `"/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_adf_account_name"></a> [adf\_account\_name](#output\_adf\_account\_name) | Azure Data Factory Name |
| <a name="output_adf_factory_id"></a> [adf\_factory\_id](#output\_adf\_factory\_id) | n/a |
| <a name="output_adf_managed_identity"></a> [adf\_managed\_identity](#output\_adf\_managed\_identity) | Azure Data Factory Name |
<!-- END_TF_DOCS -->