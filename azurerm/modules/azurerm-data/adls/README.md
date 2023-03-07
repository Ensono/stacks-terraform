# PROJECT_NAME

DESCRIPTION:
---
Bootstraps the infrastructure for {{SELECT_APP_TYPE }}. 

Will be used within the provisioned pipeline for your application depending on the options you chose.

Pipeline implementation for infrastructure relies on workspaces, you can pass in whatever workspace you want from {{ SELECT_DEPLOYMENT_TYPE }} pipeline YAML.

PREREQUISITES:
---
Azure Subscripion
  - SPN 
    - Terraform will use this to perform the authentication for the API calls
    - you will need the `client_id, subscription_id, client_secret, tenant_id`

Terraform backend
  - resource group (can be manually created for the terraform remote state)
  - Blob storage container for the remote state management


USAGE:
---

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

To get up and running locally you will want to create  a `terraform.tfvars` file 
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

```
terraform workspace select dev || terraform workspace new dev
```

terraform init -backend-config=./backend.local.tfvars
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.13)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.0)

## Resources

The following resources are used by this module:

- [azurerm_storage_account.additional_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_account.adls_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_blob.additional_storage_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) (resource)
- [azurerm_storage_container.additional_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_storage_data_lake_gen2_filesystem.adls_lake_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_create_additional_blob"></a> [create\_additional\_blob](#input\_create\_additional\_blob)

Description: If set to yes, it will create a blob storage inside additional container

Type: `bool`

### <a name="input_create_additional_container"></a> [create\_additional\_container](#input\_create\_additional\_container)

Description: If set to yes, it will create a container within the additional storage account

Type: `bool`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Resource Group Name

Type: `string`

### <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name)

Description: Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_additional_account_replication_type"></a> [additional\_account\_replication\_type](#input\_additional\_account\_replication\_type)

Description: Additional Storage Account replication type

Type: `string`

Default: `"LRS"`

### <a name="input_additional_account_tier"></a> [additional\_account\_tier](#input\_additional\_account\_tier)

Description: Tier for the additional storage account

Type: `string`

Default: `"Standard"`

### <a name="input_adls_account_kind"></a> [adls\_account\_kind](#input\_adls\_account\_kind)

Description: (OPTIONAL) Defines the Kind of account - available options are: BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing the account\_kind value from Storage to StorageV2 will not trigger a force new on the storage account, it will only upgrade the existing storage account from Storage to StorageV2 keeping the existing storage account in place.

Type: `string`

Default: `"StorageV2"`

### <a name="input_adls_account_replication_type"></a> [adls\_account\_replication\_type](#input\_adls\_account\_replication\_type)

Description: The ADLS Storage Account replication type

Type: `string`

Default: `"LRS"`

### <a name="input_adls_account_tier"></a> [adls\_account\_tier](#input\_adls\_account\_tier)

Description: Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created.

Type: `string`

Default: `"Standard"`

### <a name="input_adls_containers"></a> [adls\_containers](#input\_adls\_containers)

Description: ADLS containers to create, for example: curated, staging, raw

Type: `set(string)`

Default:

```json
[
  "curated",
  "staging",
  "raw"
]
```

### <a name="input_adls_hns_enabled"></a> [adls\_hns\_enabled](#input\_adls\_hns\_enabled)

Description: Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created.

Type: `bool`

Default: `true`

### <a name="input_attributes"></a> [attributes](#input\_attributes)

Description: Additional attributes for tagging

Type: `list`

Default: `[]`

### <a name="input_blob_type"></a> [blob\_type](#input\_blob\_type)

Description: The type of the storage blob to be created. Possible values are Append, Block or Page

Type: `string`

Default: `"Block"`

### <a name="input_create_additional_storage"></a> [create\_additional\_storage](#input\_create\_additional\_storage)

Description: If set to yes, it will create a separate storage account, storage container and a blob

Type: `bool`

Default: `false`

### <a name="input_location_name_map"></a> [location\_name\_map](#input\_location\_name\_map)

Description: Each region must have corresponding a shortend name for resource naming purposes

Type: `map(string)`

Default:

```json
{
  "eastasia": "ase",
  "eastus": "use",
  "eastus2": "use2",
  "northeurope": "eun",
  "southeastasia": "asse",
  "uksouth": "uks",
  "ukwest": "ukw",
  "westeurope": "euw",
  "westus": "usw"
}
```

### <a name="input_region"></a> [region](#input\_region)

Description: Region

Type: `string`

Default: `"northeurope"`

### <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location)

Description: n/a

Type: `string`

Default: `"uksouth"`

### <a name="input_resource_namer"></a> [resource\_namer](#input\_resource\_namer)

Description: This should be a uniformly created string - ideally using something like cloudposse label module to ensure conventions on naming are followed throughout organization. this value is used in all the places within the module to name resources - additionally it changes the string to ensure it conforms to Azure standards where appropriate - i.e. blob/KV/ACR names are stripped of non alphanumeric characters and in some cases strings are sliced to conform to max char length

Type: `string`

Default: `"genericname"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags to be assigned to all resources, NB if global tagging is enabled these will get overwritten periodically

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_adls_storage_account_id"></a> [adls\_storage\_account\_id](#output\_adls\_storage\_account\_id)

Description: The ID of the Storage Account.

### <a name="output_adls_storage_account_primary_dfs_endpoint"></a> [adls\_storage\_account\_primary\_dfs\_endpoint](#output\_adls\_storage\_account\_primary\_dfs\_endpoint)

Description: The endpoint URL for DFS storage in the primary location.

### <a name="output_default_storage_account_primary_blob_endpoint"></a> [default\_storage\_account\_primary\_blob\_endpoint](#output\_default\_storage\_account\_primary\_blob\_endpoint)

Description: The endpoint URL for blob storage in the primary location.
