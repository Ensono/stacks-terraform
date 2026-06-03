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

| Name                                                                                                                                                                   | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_storage_account.storage_account_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)                     | resource |
| [azurerm_storage_container.storage_container_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)                  | resource |
| [azurerm_storage_data_lake_gen2_filesystem.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) | resource |

## Inputs

| Name                                                                                                      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | Type                                                                                                                                                            | Default                                                                                                                                                                                                                                                                                                                                                                                                                                  | Required |
| --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_account_replication_type"></a> [account_replication_type](#input_account_replication_type) | The Storage Account replication type. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.                                                                                                                                                                                                                                                                                                                                                                                                                          | `string`                                                                                                                                                        | `"LRS"`                                                                                                                                                                                                                                                                                                                                                                                                                                  |    no    |
| <a name="input_container_access_type"></a> [container_access_type](#input_container_access_type)          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | `string`                                                                                                                                                        | `"The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."`                                                                                                                                                                                                                                                                                                                 |    no    |
| <a name="input_location_name_map"></a> [location_name_map](#input_location_name_map)                      | Each region must have corresponding a shortend name for resource naming purposes                                                                                                                                                                                                                                                                                                                                                                                                                                        | `map(string)`                                                                                                                                                   | <pre>{<br> "eastasia": "ase",<br> "eastus": "use",<br> "eastus2": "use2",<br> "northeurope": "eun",<br> "southeastasia": "asse",<br> "uksouth": "uks",<br> "ukwest": "ukw",<br> "westeurope": "euw",<br> "westus": "usw"<br>}</pre>                                                                                                                                                                                                      |    no    |
| <a name="input_resource_group_location"></a> [resource_group_location](#input_resource_group_location)    | Location of the resource group                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `string`                                                                                                                                                        | `"uksouth"`                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                | Resource Group Name                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `string`                                                                                                                                                        | n/a                                                                                                                                                                                                                                                                                                                                                                                                                                      |   yes    |
| <a name="input_resource_namer"></a> [resource_namer](#input_resource_namer)                               | Caller defined conventional namespace will be used in all resource naming. Where required by the platform special characters will be stripped out and length will be adjusted                                                                                                                                                                                                                                                                                                                                           | `string`                                                                                                                                                        | n/a                                                                                                                                                                                                                                                                                                                                                                                                                                      |   yes    |
| <a name="input_resource_tags"></a> [resource_tags](#input_resource_tags)                                  | Map of tags to be applied to all resources created as part of this module                                                                                                                                                                                                                                                                                                                                                                                                                                               | `map(string)`                                                                                                                                                   | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                     |    no    |
| <a name="input_storage_account_details"></a> [storage_account_details](#input_storage_account_details)    | The default value for this variable includes two objects, data_config_storage and data_lake_storage. The data_config_storage object has BlobStorage type, standard tier, and a single config container. The data_lake_storage object has StorageV2 type, standard tier, Hierarchical Namespace enabled, and three containers named curated, staging, and raw. Depending on the value of `hns_enabled` it will create either a Blob storage, or Gen2 Data Lake filesystem, with the names specified in `containers_name` | <pre>map(object({<br> account_tier = string<br> account_kind = string<br> name = string<br> hns_enabled = bool<br> containers_name = list(string)<br> }))</pre> | <pre>{<br> "data_config_storage": {<br> "account_kind": "StorageV2",<br> "account_tier": "Standard",<br> "containers_name": [<br> "config"<br> ],<br> "hns_enabled": false,<br> "name": "config"<br> },<br> "data_lake_storage": {<br> "account_kind": "StorageV2",<br> "account_tier": "Standard",<br> "containers_name": [<br> "curated",<br> "staging",<br> "raw"<br> ],<br> "hns_enabled": true,<br> "name": "adls"<br> }<br>}</pre> |    no    |

## Outputs

| Name                                                                                                                                                           | Description |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_primary_blob_connection_string"></a> [primary_blob_connection_string](#output_primary_blob_connection_string)                                  | n/a         |
| <a name="output_primary_blob_endpoints"></a> [primary_blob_endpoints](#output_primary_blob_endpoints)                                                          | n/a         |
| <a name="output_primary_dfs_endpoints"></a> [primary_dfs_endpoints](#output_primary_dfs_endpoints)                                                             | n/a         |
| <a name="output_storage_account_id_1"></a> [storage_account_id_1](#output_storage_account_id_1)                                                                | n/a         |
| <a name="output_storage_account_ids"></a> [storage_account_ids](#output_storage_account_ids)                                                                   | n/a         |
| <a name="output_storage_account_names"></a> [storage_account_names](#output_storage_account_names)                                                             | n/a         |
| <a name="output_storage_account_primary_connection_string"></a> [storage_account_primary_connection_string](#output_storage_account_primary_connection_string) | n/a         |
