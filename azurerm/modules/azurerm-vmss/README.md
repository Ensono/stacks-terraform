<!-- BEGIN_TF_DOCS -->
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
This module was written to quickly provision a VMSS which will be used as a self hosted build agent within Azure DevOps.

export ARM_CLIENT_ID=xxxx \
ARM_CLIENT_SECRET=yyyyy \
ARM_SUBSCRIPTION_ID=yyyyy \
ARM_TENANT_ID=yyyyy

alternatively you can run az login

To get up and running locally you will want to create a terraform.tfvars file

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
terraform workspace select dev || terraform workspace new dev
terraform init -backend-config=./backend.local.tfvars

## Known Limitiations
Work is required to enhance this module to cover wider use cases of VMSS as well as using dynatmic blocks etc to support multiple NICs and IP Configurations.

Future work should also be done to implement a packer image build. This will allow us to build the base image once and speed up the time taken to start new agents as all tools will be installed within the assigned image.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [local_file.sh](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | Name of the IP Config on the VMs NIC. | `string` | `"primary"` | no |
| <a name="input_location_name_map"></a> [location\_name\_map](#input\_location\_name\_map) | Each region must have corresponding a shortend name for resource naming purposes | `map(string)` | <pre>{<br>  "eastasia": "ase",<br>  "eastus": "use",<br>  "eastus2": "use2",<br>  "northeurope": "eun",<br>  "southeastasia": "asse",<br>  "uksouth": "uks",<br>  "ukwest": "ukw",<br>  "westeurope": "euw",<br>  "westus": "usw"<br>}</pre> | no |
| <a name="input_network_interface_name"></a> [network\_interface\_name](#input\_network\_interface\_name) | Name of the VMs NIC. | `string` | `"primary"` | no |
| <a name="input_overprovision"></a> [overprovision](#input\_overprovision) | Bool to set overprovisioning. | `bool` | `false` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the  Subnet which the VMSS will be provisioned. | `string` | `""` | no |
| <a name="input_vmss_admin_password"></a> [vmss\_admin\_password](#input\_vmss\_admin\_password) | Password for Admin SSH Access to VMs. | `string` | `""` | no |
| <a name="input_vmss_admin_username"></a> [vmss\_admin\_username](#input\_vmss\_admin\_username) | Username for Admin SSH Access to VMs. | `string` | `""` | no |
| <a name="input_vmss_disable_password_auth"></a> [vmss\_disable\_password\_auth](#input\_vmss\_disable\_password\_auth) | Boolean to enable or disable password authentication to VMs. | `bool` | `false` | no |
| <a name="input_vmss_disk_caching"></a> [vmss\_disk\_caching](#input\_vmss\_disk\_caching) | Disk Caching options. | `string` | `"ReadWrite"` | no |
| <a name="input_vmss_image_offer"></a> [vmss\_image\_offer](#input\_vmss\_image\_offer) | Image offer. Eg UbuntuServer | `string` | `"0001-com-ubuntu-server-jammy"` | no |
| <a name="input_vmss_image_publisher"></a> [vmss\_image\_publisher](#input\_vmss\_image\_publisher) | Image Publisher. | `string` | `"Canonical"` | no |
| <a name="input_vmss_image_sku"></a> [vmss\_image\_sku](#input\_vmss\_image\_sku) | Image SKU. | `string` | `"22_04-lts-gen2"` | no |
| <a name="input_vmss_image_version"></a> [vmss\_image\_version](#input\_vmss\_image\_version) | Version of VM Image SKU required. | `string` | `"latest"` | no |
| <a name="input_vmss_instances"></a> [vmss\_instances](#input\_vmss\_instances) | Default number of instances within the scaleset. | `number` | `1` | no |
| <a name="input_vmss_name"></a> [vmss\_name](#input\_vmss\_name) | Name of the VMSS | `string` | `""` | no |
| <a name="input_vmss_resource_group_location"></a> [vmss\_resource\_group\_location](#input\_vmss\_resource\_group\_location) | Location of Resource group | `string` | `"uksouth"` | no |
| <a name="input_vmss_resource_group_name"></a> [vmss\_resource\_group\_name](#input\_vmss\_resource\_group\_name) | name of resource group | `string` | `""` | no |
| <a name="input_vmss_sku"></a> [vmss\_sku](#input\_vmss\_sku) | VM Size | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_vmss_storage_account_type"></a> [vmss\_storage\_account\_type](#input\_vmss\_storage\_account\_type) | Storeage type used for VMSS Disk. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the VNET which the VMSS will be provisioned. | `string` | `""` | no |
| <a name="input_vnet_resource_group"></a> [vnet\_resource\_group](#input\_vnet\_resource\_group) | Name of the Resource Group in which the VNET is provisioned. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vmss_admin_password"></a> [vmss\_admin\_password](#output\_vmss\_admin\_password) | n/a |
| <a name="output_vmss_id"></a> [vmss\_id](#output\_vmss\_id) | n/a |
<!-- END_TF_DOCS -->