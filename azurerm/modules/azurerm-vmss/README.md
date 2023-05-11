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
| <a name="input_create_networking"></a> [create\_networking](#input\_create\_networking) | n/a | `bool` | `false` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | n/a | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | n/a | `string` | `""` | no |
| <a name="input_vmss_admin_password"></a> [vmss\_admin\_password](#input\_vmss\_admin\_password) | n/a | `string` | `""` | no |
| <a name="input_vmss_admin_username"></a> [vmss\_admin\_username](#input\_vmss\_admin\_username) | n/a | `string` | `""` | no |
| <a name="input_vmss_disable_password_auth"></a> [vmss\_disable\_password\_auth](#input\_vmss\_disable\_password\_auth) | n/a | `bool` | `false` | no |
| <a name="input_vmss_disk_caching"></a> [vmss\_disk\_caching](#input\_vmss\_disk\_caching) | n/a | `string` | `"ReadWrite"` | no |
| <a name="input_vmss_image_offer"></a> [vmss\_image\_offer](#input\_vmss\_image\_offer) | n/a | `string` | `"UbuntuServer"` | no |
| <a name="input_vmss_image_publisher"></a> [vmss\_image\_publisher](#input\_vmss\_image\_publisher) | n/a | `string` | `"Canonical"` | no |
| <a name="input_vmss_image_sku"></a> [vmss\_image\_sku](#input\_vmss\_image\_sku) | n/a | `string` | `"20.04-LTS"` | no |
| <a name="input_vmss_image_version"></a> [vmss\_image\_version](#input\_vmss\_image\_version) | n/a | `string` | `"latest"` | no |
| <a name="input_vmss_instances"></a> [vmss\_instances](#input\_vmss\_instances) | n/a | `number` | `1` | no |
| <a name="input_vmss_name"></a> [vmss\_name](#input\_vmss\_name) | n/a | `string` | `""` | no |
| <a name="input_vmss_sku"></a> [vmss\_sku](#input\_vmss\_sku) | n/a | `string` | `"Standard_D2_v3"` | no |
| <a name="input_vmss_storage_account_type"></a> [vmss\_storage\_account\_type](#input\_vmss\_storage\_account\_type) | n/a | `string` | `"Standard_LRS"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | n/a | `string` | `""` | no |
| <a name="input_vnet_resource_group"></a> [vnet\_resource\_group](#input\_vnet\_resource\_group) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vmss_id"></a> [vmss\_id](#output\_vmss\_id) | n/a |
