## Known Limitations
This module was written to quickly provision a VMSS which will be used as a self hosted build agent within Azure DevOps.

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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | Name of the IP Config on the VMs NIC. | `string` | `"primary"` | no |
| <a name="input_location_name_map"></a> [location\_name\_map](#input\_location\_name\_map) | Each region must have corresponding a shortend name for resource naming purposes | `map(string)` | <pre>{<br>  "eastasia": "ase",<br>  "eastus": "use",<br>  "eastus2": "use2",<br>  "northeurope": "eun",<br>  "southeastasia": "asse",<br>  "uksouth": "uks",<br>  "ukwest": "ukw",<br>  "westeurope": "euw",<br>  "westus": "usw"<br>}</pre> | no |
| <a name="input_network_interface_name"></a> [network\_interface\_name](#input\_network\_interface\_name) | Name of the VMs NIC. | `string` | `"primary"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the  Subnet which the VMSS will be provisioned. | `string` | `""` | no |
| <a name="input_vmss_admin_password"></a> [vmss\_admin\_password](#input\_vmss\_admin\_password) | Password for Admin SSH Access to VMs. | `string` | `""` | no |
| <a name="input_vmss_admin_username"></a> [vmss\_admin\_username](#input\_vmss\_admin\_username) | Username for Admin SSH Access to VMs. | `string` | `""` | no |
| <a name="input_vmss_disable_password_auth"></a> [vmss\_disable\_password\_auth](#input\_vmss\_disable\_password\_auth) | Boolean to enable or disable password authentication to VMs. | `bool` | `false` | no |
| <a name="input_vmss_disk_caching"></a> [vmss\_disk\_caching](#input\_vmss\_disk\_caching) | Disk Caching options. | `string` | `"ReadWrite"` | no |
| <a name="input_vmss_image_offer"></a> [vmss\_image\_offer](#input\_vmss\_image\_offer) | Image offer. Eg UbuntuServer | `string` | `"UbuntuServer"` | no |
| <a name="input_vmss_image_publisher"></a> [vmss\_image\_publisher](#input\_vmss\_image\_publisher) | Image Publisher. | `string` | `"Canonical"` | no |
| <a name="input_vmss_image_sku"></a> [vmss\_image\_sku](#input\_vmss\_image\_sku) | Image SKU. | `string` | `"20.04-LTS"` | no |
| <a name="input_vmss_image_version"></a> [vmss\_image\_version](#input\_vmss\_image\_version) | Version of VM Image SKU required. | `string` | `"latest"` | no |
| <a name="input_vmss_instances"></a> [vmss\_instances](#input\_vmss\_instances) | Default number of instances within the scaleset. | `number` | `1` | no |
| <a name="input_vmss_name"></a> [vmss\_name](#input\_vmss\_name) | Name of the VMSS | `string` | `""` | no |
| <a name="input_vmss_resource_group_location"></a> [vmss\_resource\_group\_location](#input\_vmss\_resource\_group\_location) | Location of Resource group | `string` | `"uksouth"` | no |
| <a name="input_vmss_resource_group_name"></a> [vmss\_resource\_group\_name](#input\_vmss\_resource\_group\_name) | name of resource group | `string` | n/a | yes |
| <a name="input_vmss_sku"></a> [vmss\_sku](#input\_vmss\_sku) | VM Size | `string` | `"Standard_D2_v3"` | no |
| <a name="input_vmss_storage_account_type"></a> [vmss\_storage\_account\_type](#input\_vmss\_storage\_account\_type) | Storeage type used for VMSS Disk. | `string` | `"Standard_LRS"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the VNET which the VMSS will be provisioned. | `string` | `""` | no |
| <a name="input_vnet_resource_group"></a> [vnet\_resource\_group](#input\_vnet\_resource\_group) | Name of the Resource Group in which the VNET is provisioned. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vmss_id"></a> [vmss\_id](#output\_vmss\_id) | n/a |
