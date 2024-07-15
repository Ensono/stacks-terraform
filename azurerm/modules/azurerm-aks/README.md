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

| Name | Version |
|------|---------|
| azurerm | n/a |
| tls | n/a |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_container_registry.registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_dns_ns_record.parent_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_key_vault.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_kubernetes_cluster.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.additional](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_log_analytics_solution.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.external_ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.acr2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rg_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_user_assigned_identity.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.spn_client](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_container_registry.acr_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |
| [azurerm_dns_zone.parent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_resource_group.aks_rg_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_user_assigned_identity.aks_rg_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_registry_name"></a> [acr\_registry\_name](#input\_acr\_registry\_name) | ACR name | `string` | `"myacrregistry"` | no |
| <a name="input_acr_resource_group"></a> [acr\_resource\_group](#input\_acr\_resource\_group) | Supply your own resource group name for ACR | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | n/a | `string` | `"ubuntu"` | no |
| <a name="input_advanced_networking_enabled"></a> [advanced\_networking\_enabled](#input\_advanced\_networking\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_aks_ingress_private_ip"></a> [aks\_ingress\_private\_ip](#input\_aks\_ingress\_private\_ip) | n/a | `string` | n/a | yes |
| <a name="input_aks_node_pools"></a> [aks\_node\_pools](#input\_aks\_node\_pools) | Additional node pools as required by the platform | <pre>map(object({<br>    vm_size      = string,<br>    auto_scaling = bool,<br>    min_nodes    = number,<br>    max_nodes    = number<br>  }))</pre> | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes for tagging | `list` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name for the cluster | `string` | `"akscluster"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Specify AKS cluster version - please refer to MS for latest updates on the available versions. NB: opt for stable versions where possible | `string` | `"1.24.6"` | no |
| <a name="input_create_acr"></a> [create\_acr](#input\_create\_acr) | whether to create a ACR | `bool` | `true` | no |
| <a name="input_create_aks"></a> [create\_aks](#input\_create\_aks) | Whether KAS gets created | `bool` | `true` | no |
| <a name="input_create_aksvnet"></a> [create\_aksvnet](#input\_create\_aksvnet) | Whether to create an AKS VNET specifically or use an existing one - if false you must supply an existing VNET name and a vnet\_cidr for subnets | `bool` | `true` | no |
| <a name="input_create_dns_zone"></a> [create\_dns\_zone](#input\_create\_dns\_zone) | whether to create a DNS zone | `bool` | `true` | no |
| <a name="input_create_key_vault"></a> [create\_key\_vault](#input\_create\_key\_vault) | Specify if a key vault should be created | `bool` | `true` | no |
| <a name="input_create_ssh_key"></a> [create\_ssh\_key](#input\_create\_ssh\_key) | n/a | `bool` | `true` | no |
| <a name="input_create_user_identity"></a> [create\_user\_identity](#input\_create\_user\_identity) | Creates a User Managed Identity - which can be used subsquently with AAD pod identity extensions | `bool` | `true` | no |
| <a name="input_dns_create_parent_zone_ns_records"></a> [dns\_create\_parent\_zone\_ns\_records](#input\_dns\_create\_parent\_zone\_ns\_records) | Whether to create an NS record in the parent zone linking the created DNS zone up | `bool` | `true` | no |
| <a name="input_dns_parent_ns_ttl"></a> [dns\_parent\_ns\_ttl](#input\_dns\_parent\_ns\_ttl) | The TTL for the NS Record in the Parent Zone | `string` | `300` | no |
| <a name="input_dns_parent_resource_group"></a> [dns\_parent\_resource\_group](#input\_dns\_parent\_resource\_group) | RG that contains the existing parent DNS zone | `string` | `null` | no |
| <a name="input_dns_parent_zone"></a> [dns\_parent\_zone](#input\_dns\_parent\_zone) | Dns zone name for the parnet - e.g. domain.com. NOTE: you need control over this domain to add the records here | `string` | `""` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | n/a | `string` | `"aks"` | no |
| <a name="input_dns_resource_group"></a> [dns\_resource\_group](#input\_dns\_resource\_group) | RG that contains the existing DNS zones, if the zones are not being created here | `string` | `null` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | Dns zone name - e.g. nonprod.domain.com, you should avoid using an APEX zone | `string` | `""` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | n/a | `bool` | `false` | no |
| <a name="input_internal_dns_zone"></a> [internal\_dns\_zone](#input\_internal\_dns\_zone) | Internal DNS zone name - e.g. nonprod.domain.internal | `string` | `""` | no |
| <a name="input_is_cluster_private"></a> [is\_cluster\_private](#input\_is\_cluster\_private) | Whether or not expose the Ingress over internet | `bool` | `false` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key Vault name - if not specificied will default to computed naming convention | `string` | `""` | no |
| <a name="input_log_application_type"></a> [log\_application\_type](#input\_log\_application\_type) | Log application type | `string` | `"other"` | no |
| <a name="input_max_nodes"></a> [max\_nodes](#input\_max\_nodes) | n/a | `number` | `10` | no |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | n/a | `number` | `100` | no |
| <a name="input_min_nodes"></a> [min\_nodes](#input\_min\_nodes) | n/a | `number` | `1` | no |
| <a name="input_name_company"></a> [name\_company](#input\_name\_company) | Company Name - should/will be used in conventional resource naming | `string` | n/a | yes |
| <a name="input_name_component"></a> [name\_component](#input\_name\_component) | Component Name - should/will be used in conventional resource naming. Typically this will be a logical name for this part of the system i.e. `API` \|\| `middleware` or more generic like `Billing` | `string` | n/a | yes |
| <a name="input_name_environment"></a> [name\_environment](#input\_name\_environment) | n/a | `string` | n/a | yes |
| <a name="input_name_project"></a> [name\_project](#input\_name\_project) | Project Name - should/will be used in conventional resource naming | `string` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | n/a | `number` | `0` | no |
| <a name="input_nodepool_type"></a> [nodepool\_type](#input\_nodepool\_type) | n/a | `string` | `"VirtualMachineScaleSets"` | no |
| <a name="input_oms_ws_list_of_one"></a> [oms\_ws\_list\_of\_one](#input\_oms\_ws\_list\_of\_one) | n/a | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_os_disk_size"></a> [os\_disk\_size](#input\_os\_disk\_size) | DEFAULTS TO 30 if not overwritten | `number` | `30` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Set cluster access private | `bool` | `false` | no |
| <a name="input_registry_admin_enabled"></a> [registry\_admin\_enabled](#input\_registry\_admin\_enabled) | Whether ACR admin is enabled | `bool` | `true` | no |
| <a name="input_registry_sku"></a> [registry\_sku](#input\_registry\_sku) | ACR SKU | `string` | `"Standard"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the RG | `string` | `"uksouth"` | no |
| <a name="input_resource_group_tags"></a> [resource\_group\_tags](#input\_resource\_group\_tags) | Tags at a RG level | `map(string)` | `{}` | no |
| <a name="input_resource_namer"></a> [resource\_namer](#input\_resource\_namer) | This should be a uniformly created string - ideally using something like cloudposse label module to ensure conventions on naming are followed throughout organization. this value is used in all the places within the module to name resources - additionally it changes the string to ensure it conforms to Azure standards where appropriate - i.e. blob/KV/ACR names are stripped of non alphanumeric characters and in some cases strings are sliced to conform to max char length | `string` | `"genericname"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | n/a | `number` | `30` | no |
| <a name="input_spn_object_id"></a> [spn\_object\_id](#input\_spn\_object\_id) | n/a | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | n/a | `string` | `"dev"` | no |
| <a name="input_subnet_front_end_prefix"></a> [subnet\_front\_end\_prefix](#input\_subnet\_front\_end\_prefix) | Prefix for front end subnet - should be in the form of x.x.x.x/x | `string` | n/a | yes |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | Names for subnets | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_subnet_prefixes"></a> [subnet\_prefixes](#input\_subnet\_prefixes) | Prefix for subnet - should be in the form of x.x.x.x/x | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be assigned to all resources, NB if global tagging is enabled these will get overwritten periodically | `map(string)` | `{}` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | n/a | `string` | `"Standard_DS2_v2"` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | CIDR block notation for VNET | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | VNET name if create\_aks\_vnet is false | `string` | `""` | no |
| <a name="input_vnet_name_resource_group"></a> [vnet\_name\_resource\_group](#input\_vnet\_name\_resource\_group) | VNET resource group name if user supplying an existing network | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_registry_name"></a> [acr\_registry\_name](#output\_acr\_registry\_name) | Created ACR name |
| <a name="output_acr_resource_group_name"></a> [acr\_resource\_group\_name](#output\_acr\_resource\_group\_name) | Created ACR resource group Name |
| <a name="output_aks_cluster_name"></a> [aks\_cluster\_name](#output\_aks\_cluster\_name) | Created AKS resource group Name |
| <a name="output_aks_default_user_identity_client_id"></a> [aks\_default\_user\_identity\_client\_id](#output\_aks\_default\_user\_identity\_client\_id) | n/a |
| <a name="output_aks_default_user_identity_id"></a> [aks\_default\_user\_identity\_id](#output\_aks\_default\_user\_identity\_id) | n/a |
| <a name="output_aks_default_user_identity_name"></a> [aks\_default\_user\_identity\_name](#output\_aks\_default\_user\_identity\_name) | ######################################## ############ Identity ################## ## used for AAD Pod identity binding ### ######################################## |
| <a name="output_aks_ingress_private_ip"></a> [aks\_ingress\_private\_ip](#output\_aks\_ingress\_private\_ip) | n/a |
| <a name="output_aks_ingress_public_ip"></a> [aks\_ingress\_public\_ip](#output\_aks\_ingress\_public\_ip) | n/a |
| <a name="output_aks_node_resource_group"></a> [aks\_node\_resource\_group](#output\_aks\_node\_resource\_group) | n/a |
| <a name="output_aks_resource_group_name"></a> [aks\_resource\_group\_name](#output\_aks\_resource\_group\_name) | Created AKS resource group Name |
| <a name="output_aks_system_identity_principal_id"></a> [aks\_system\_identity\_principal\_id](#output\_aks\_system\_identity\_principal\_id) | #########azurerm\_kubernetes\_cluster.default.identity.principal\_id |
| <a name="output_app_insights_id"></a> [app\_insights\_id](#output\_app\_insights\_id) | n/a |
| <a name="output_app_insights_key"></a> [app\_insights\_key](#output\_app\_insights\_key) | n/a |
| <a name="output_app_insights_name"></a> [app\_insights\_name](#output\_app\_insights\_name) | n/a |
| <a name="output_app_insights_resource_group_name"></a> [app\_insights\_resource\_group\_name](#output\_app\_insights\_resource\_group\_name) | n/a |
| <a name="output_dns_base_domain"></a> [dns\_base\_domain](#output\_dns\_base\_domain) | TODO: This is not even the Base DNS, it's the Environment DNS, terminology needs tidying up..? |
| <a name="output_dns_base_domain_internal"></a> [dns\_base\_domain\_internal](#output\_dns\_base\_domain\_internal) | n/a |
| <a name="output_dns_base_domain_name_servers"></a> [dns\_base\_domain\_name\_servers](#output\_dns\_base\_domain\_name\_servers) | n/a |
| <a name="output_dns_internal_resource_group_name"></a> [dns\_internal\_resource\_group\_name](#output\_dns\_internal\_resource\_group\_name) | n/a |
| <a name="output_dns_resource_group_name"></a> [dns\_resource\_group\_name](#output\_dns\_resource\_group\_name) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | Created resource group Id |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Created resource group Name |
| <a name="output_vnet_address_id"></a> [vnet\_address\_id](#output\_vnet\_address\_id) | Specified VNET Id |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | Specified VNET address space |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Created VNET name.<br>Name can be deduced however it's better to create a direct dependency |

EXAMPLES:
---
There is an examples folder with possible usage patterns.

`entire-infra`
