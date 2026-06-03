<!-- BEGIN_TF_DOCS -->

# PROJECT_NAME

## DESCRIPTION

Bootstraps the infrastructure for {{SELECT_APP_TYPE }}.

Will be used within the provisioned pipeline for your application depending on the options you chose.

Pipeline implementation for infrastructure relies on workspaces, you can pass in whatever workspace you want from {{ SELECT_DEPLOYMENT_TYPE }} pipeline YAML.

## PREREQUISITES

Azure Subscription

- SPN
  - Terraform will use this to perform the authentication for the API calls
  - you will need the `client_id, subscription_id, client_secret, tenant_id`

Terraform backend

- resource group (can be manually created for the terraform remote state)
- Blob storage container for the remote state management

## USAGE

To activate the terraform backend for running locally we need to initialise the SPN with env vars to ensure you are running the same way as the pipeline that will ultimately be running any incremental changes.

```bash
docker run -it --rm -v $(pwd):/opt/tf-lib amidostacks/ci-tf:latest /bin/bash
```

```bash
export ARM_CLIENT_ID=xxxx \
ARM_CLIENT_SECRET=yyyyy \
ARM_SUBSCRIPTION_ID=yyyyy \
ARM_TENANT_ID=yyyyy
```

alternatively you can run `az login`

To get up and running locally you will want to create a `terraform.tfvars` file

```bash
TFVAR_CONTENTS='''
vnet_id                 = "amido-stacks-vnet-uks-dev"
rg_name                 = "amido-stacks-rg-uks-dev"
resource_group_location = "uksouth"
name_company            = "amido"
name_project            = "stacks"
name_component          = "spa"
name_environment        = "dev"
'''
$TFVAR_CONTENTS > terraform.tfvars
```

```bash
terraform workspace select dev || terraform workspace new dev
```

terraform init -backend-config=./backend.local.tfvars

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

| Name                                                                                                                                                                             | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [azurerm_data_factory.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory)                                                     | resource    |
| [azurerm_data_factory_integration_runtime_azure.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure) | resource    |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)                                                | data source |

## Inputs

| Name                                                                                                                           | Description                                                                                                                                                                                         | Type                                                                                    | Default                                                                                               | Required |
| ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_adf_idenity"></a> [adf_idenity](#input_adf_idenity)                                                             | Enable identity block in module.                                                                                                                                                                    | `bool`                                                                                  | `true`                                                                                                |    no    |
| <a name="input_adf_managed-vnet-runtime_name"></a> [adf_managed-vnet-runtime_name](#input_adf_managed-vnet-runtime_name)       | Specifies the name of the Managed Integration Runtime. Changing this forces a new resource to be created. Must be globally unique. See the Microsoft documentation for all restrictions.            | `string`                                                                                | `"adf-managed-vnet-runtime"`                                                                          |    no    |
| <a name="input_branch_name"></a> [branch_name](#input_branch_name)                                                             | Specifies repository branch to use as the collaboration branch.                                                                                                                                     | `string`                                                                                | `"main"`                                                                                              |    no    |
| <a name="input_create_adf"></a> [create_adf](#input_create_adf)                                                                | Set value whether to create a Data Factory or not.                                                                                                                                                  | `bool`                                                                                  | `true`                                                                                                |    no    |
| <a name="input_git_integration"></a> [git_integration](#input_git_integration)                                                 | Integrate a git repository with ADF. Can be null, github or vsts (use vsts for Azure DevOps Repos).                                                                                                 | `string`                                                                                | `"null"`                                                                                              |    no    |
| <a name="input_github_account_name"></a> [github_account_name](#input_github_account_name)                                     | Specifies the GitHub account name.                                                                                                                                                                  | `string`                                                                                | `"amido"`                                                                                             |    no    |
| <a name="input_github_url"></a> [github_url](#input_github_url)                                                                | Specifies the GitHub Enterprise host name. For example: <https://github.mydomain.com>. Use <https://github.com> for open source repositories.                                                       | `string`                                                                                | `"https://github.com"`                                                                                |    no    |
| <a name="input_global_parameter"></a> [global_parameter](#input_global_parameter)                                              | Specifies whether to add global parameters to ADF                                                                                                                                                   | <pre>list(object({<br> name = string<br> type = string<br> value = string<br> }))</pre> | <pre>[<br> {<br> "name": "environment",<br> "type": "String",<br> "value": "nonprod"<br> }<br>]</pre> |    no    |
| <a name="input_identity_ids"></a> [identity_ids](#input_identity_ids)                                                          | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Data Factory.                                                                                                         | `list(string)`                                                                          | `[]`                                                                                                  |    no    |
| <a name="input_identity_type"></a> [identity_type](#input_identity_type)                                                       | Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned,UserAssigned (to enable both).      | `string`                                                                                | `"SystemAssigned"`                                                                                    |    no    |
| <a name="input_managed_virtual_network_enabled"></a> [managed_virtual_network_enabled](#input_managed_virtual_network_enabled) | Is Managed Virtual Network enabled?                                                                                                                                                                 | `bool`                                                                                  | `false`                                                                                               |    no    |
| <a name="input_name_component"></a> [name_component](#input_name_component)                                                    | Component Name - should/will be used in conventional resource naming. Typically this will be a logical name for this part of the system i.e. `API` \|\| `middleware` or more generic like `Billing` | `string`                                                                                | `"adf"`                                                                                               |    no    |
| <a name="input_public_network_enabled"></a> [public_network_enabled](#input_public_network_enabled)                            | Is the Data Factory visible to the public network? Defaults to true                                                                                                                                 | `bool`                                                                                  | `true`                                                                                                |    no    |
| <a name="input_repository_name"></a> [repository_name](#input_repository_name)                                                 | Specifies the name of the git repository.                                                                                                                                                           | `string`                                                                                | `"stacks-data-infrastructure"`                                                                        |    no    |
| <a name="input_resource_group_location"></a> [resource_group_location](#input_resource_group_location)                         | Location of Resource group                                                                                                                                                                          | `string`                                                                                | `"uksouth"`                                                                                           |    no    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                                     | Name of resource group                                                                                                                                                                              | `string`                                                                                | n/a                                                                                                   |   yes    |
| <a name="input_resource_namer"></a> [resource_namer](#input_resource_namer)                                                    | User defined naming convention applied to all resources created as part of this module                                                                                                              | `string`                                                                                | n/a                                                                                                   |   yes    |
| <a name="input_resource_tags"></a> [resource_tags](#input_resource_tags)                                                       | Map of tags to be applied to all resources created as part of this module                                                                                                                           | `map(string)`                                                                           | `{}`                                                                                                  |    no    |
| <a name="input_root_folder"></a> [root_folder](#input_root_folder)                                                             | Specifies the root folder within the repository. Set to / for the top level.                                                                                                                        | `string`                                                                                | `"/adf_managed"`                                                                                      |    no    |
| <a name="input_runtime_virtual_network_enabled"></a> [runtime_virtual_network_enabled](#input_runtime_virtual_network_enabled) | Is Integration Runtime compute provisioned within Managed Virtual Network? Changing this forces a new resource to be created.                                                                       | `bool`                                                                                  | `true`                                                                                                |    no    |
| <a name="input_vsts_account_name"></a> [vsts_account_name](#input_vsts_account_name)                                           | Specifies the VSTS / Azure DevOps account name.                                                                                                                                                     | `string`                                                                                | `"amido"`                                                                                             |    no    |
| <a name="input_vsts_project_name"></a> [vsts_project_name](#input_vsts_project_name)                                           | Specifies the name of the VSTS / Azure DevOps project.                                                                                                                                              | `string`                                                                                | `"amido-stacks"`                                                                                      |    no    |

## Outputs

| Name                                                                                            | Description             |
| ----------------------------------------------------------------------------------------------- | ----------------------- |
| <a name="output_adf_account_name"></a> [adf_account_name](#output_adf_account_name)             | Azure Data Factory Name |
| <a name="output_adf_factory_id"></a> [adf_factory_id](#output_adf_factory_id)                   | n/a                     |
| <a name="output_adf_managed_identity"></a> [adf_managed_identity](#output_adf_managed_identity) | Azure Data Factory Name |

## EXAMPLES

---

There is an examples folder with possible usage patterns.

`example`

<!-- END_TF_DOCS -->
