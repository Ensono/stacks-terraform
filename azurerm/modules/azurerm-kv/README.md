<!-- BEGIN_TF_DOCS -->

# PROJECT_NAME

## DESCRIPTION

Bootstraps the infrastructure for {{SELECT_APP_TYPE }}.

Will be used within the provisioned pipeline for your application depending on the options you chose.

Pipeline implementation for infrastructure relies on workspaces, you can pass in whatever workspace you want from {{ SELECT_DEPLOYMENT_TYPE }} pipeline YAML.

## PREREQUISITES

Azure Subscripion

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

| Name                                                                                                                                                                  | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [azurerm_key_vault.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)                                                | resource    |
| [azurerm_key_vault_access_policy.contributors_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource    |
| [azurerm_key_vault_access_policy.reader_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy)       | resource    |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)                                     | data source |

## Inputs

| Name                                                                                                                           | Description                                                                                                                                                                                         | Type           | Default                     | Required |
| ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | --------------------------- | :------: |
| <a name="input_contributor_object_ids"></a> [contributor_object_ids](#input_contributor_object_ids)                            | A list of Azure active directory user,group or application object ID's that will have contributor role to the key vault                                                                             | `list(string)` | `[]`                        |    no    |
| <a name="input_create_kv"></a> [create_kv](#input_create_kv)                                                                   | set value wether to create a KV or not                                                                                                                                                              | `bool`         | `true`                      |    no    |
| <a name="input_create_kv_networkacl"></a> [create_kv_networkacl](#input_create_kv_networkacl)                                  | whether to create a acl for kv or not                                                                                                                                                               | `bool`         | `false`                     |    no    |
| <a name="input_enable_rbac_authorization"></a> [enable_rbac_authorization](#input_enable_rbac_authorization)                   | whether Azure Resource Manager is permitted to retrieve secrets from the key vault                                                                                                                  | `bool`         | `false`                     |    no    |
| <a name="input_enabled_for_disk_encryption"></a> [enabled_for_disk_encryption](#input_enabled_for_disk_encryption)             | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys                                                                               | `bool`         | `true`                      |    no    |
| <a name="input_enabled_for_template_deployment"></a> [enabled_for_template_deployment](#input_enabled_for_template_deployment) | whether Azure Resource Manager is permitted to retrieve secrets from the key vault                                                                                                                  | `bool`         | `false`                     |    no    |
| <a name="input_key_permissions"></a> [key_permissions](#input_key_permissions)                                                 | List of key permissions                                                                                                                                                                             | `list(string)` | <pre>[<br> "Get"<br>]</pre> |    no    |
| <a name="input_name_component"></a> [name_component](#input_name_component)                                                    | Component Name - should/will be used in conventional resource naming. Typically this will be a logical name for this part of the system i.e. `API` \|\| `middleware` or more generic like `Billing` | `string`       | `"kv"`                      |    no    |
| <a name="input_network_acl_default_action"></a> [network_acl_default_action](#input_network_acl_default_action)                | he Name of the SKU used for this Key Vault. Possible values are standard and premium                                                                                                                | `string`       | `"Deny"`                    |    no    |
| <a name="input_network_acls_bypass"></a> [network_acls_bypass](#input_network_acls_bypass)                                     | Specifies which traffic can bypass the network rules. Possible values are AzureServices and None                                                                                                    | `string`       | `"AzureServices"`           |    no    |
| <a name="input_network_acls_ip_rules"></a> [network_acls_ip_rules](#input_network_acls_ip_rules)                               | The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny                                                                        | `list(string)` | `[]`                        |    no    |
| <a name="input_public_network_access_enabled"></a> [public_network_access_enabled](#input_public_network_access_enabled)       | Allow public network access to Key Vault. Set as true or false.                                                                                                                                     | `bool`         | `true`                      |    no    |
| <a name="input_purge_protection_enabled"></a> [purge_protection_enabled](#input_purge_protection_enabled)                      | Is Purge Protection enabled for this Key Vault                                                                                                                                                      | `bool`         | `false`                     |    no    |
| <a name="input_reader_object_ids"></a> [reader_object_ids](#input_reader_object_ids)                                           | A list of Azure active directory user,group or application object ID's that will have reader role to the key vault                                                                                  | `list(string)` | `[]`                        |    no    |
| <a name="input_resource_group_location"></a> [resource_group_location](#input_resource_group_location)                         | Location of Resource group                                                                                                                                                                          | `string`       | `"uksouth"`                 |    no    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                                     | name of resource group                                                                                                                                                                              | `string`       | n/a                         |   yes    |
| <a name="input_resource_namer"></a> [resource_namer](#input_resource_namer)                                                    | User defined naming convention applied to all resources created as part of this module                                                                                                              | `string`       | n/a                         |   yes    |
| <a name="input_resource_tags"></a> [resource_tags](#input_resource_tags)                                                       | Map of tags to be applied to all resources created as part of this module                                                                                                                           | `map(string)`  | `{}`                        |    no    |
| <a name="input_secret_permissions"></a> [secret_permissions](#input_secret_permissions)                                        | List of secret permissions, must be one or more                                                                                                                                                     | `list(string)` | <pre>[<br> "Get"<br>]</pre> |    no    |
| <a name="input_sku_name"></a> [sku_name](#input_sku_name)                                                                      | he Name of the SKU used for this Key Vault. Possible values are standard and premium                                                                                                                | `string`       | `"standard"`                |    no    |
| <a name="input_soft_delete_retention_days"></a> [soft_delete_retention_days](#input_soft_delete_retention_days)                | number of days that items should be retained for once soft-deleted. This value can be between 7 and 90                                                                                              | `number`       | `7`                         |    no    |
| <a name="input_storage_permissions"></a> [storage_permissions](#input_storage_permissions)                                     | List of storage permissions, must be one or more from the following                                                                                                                                 | `list(string)` | <pre>[<br> "Get"<br>]</pre> |    no    |
| <a name="input_virtual_network_subnet_ids"></a> [virtual_network_subnet_ids](#input_virtual_network_subnet_ids)                | One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault                                                                                                               | `list(string)` | `[]`                        |    no    |

## Outputs

| Name                                                                          | Description              |
| ----------------------------------------------------------------------------- | ------------------------ |
| <a name="output_id"></a> [id](#output_id)                                     | The ID of the Key Vault. |
| <a name="output_key_vault_name"></a> [key_vault_name](#output_key_vault_name) | n/a                      |
| <a name="output_vault_uri"></a> [vault_uri](#output_vault_uri)                | vault_uri                |

## EXAMPLES

---

There is an examples folder with possible usage patterns.

`example`

<!-- END_TF_DOCS -->
