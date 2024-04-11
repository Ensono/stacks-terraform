Stacks EKS Infrastructure
-------------------------

Spins up EKS Infrastructure into a supplied VPC. Handles Single AZ Clusters
and Multi-AZ Clusters. `eks_minimum_nodes` and `eks_maximum_nodes` apply to all
AZs, so with `cluster_single_az` set to `false` and an `eks_minimum_nodes`
value of 1 in `eu-west-2` will spin up 1 node per-AZ, i.e. 3 nodes.

This uses Managed Node Groups on Bottlerocket OS, which can either be On-Demand
or Spot Instances.

It is recommended by AWS to utilise separate Node Groups per-AZ when using
Stateful Applications, such as those using EBS as each EBS is bound to a single
AZ and mixing AZs in a Node Group can cause pods to be scheduled onto a node
utilising another subnet which will cause the pod to fail to bind the EBS.
**NOTE:** This module doesn't currently support a single Node Group
with all Available AZs in it.

**NOTE2:** When destroying the infrastructure, there's a known bug whereby the
log group won't destroy and needs to be removed manually. The downstream module
has done everything to try to fix this but it still occurs for some accounts.
See: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1019#issuecomment-697201414
and: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/920

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.20 |
| <a name="module_eks_kms_key"></a> [eks\_kms\_key](#module\_eks\_kms\_key) | ../../resource_modules/identity/kms_key | n/a |

## Resources

| Name | Type |
|------|------|
| [null_resource.cis_bootstrap_validation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_secret_encryption_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cis_bootstrap_image"></a> [cis\_bootstrap\_image](#input\_cis\_bootstrap\_image) | CIS Bootstrap image, required if enable\_cis\_bootstrap is set to true | `string` | `""` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Switch to enable private access | `bool` | n/a | yes |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Switch to enable public access | `bool` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster and resources | `string` | n/a | yes |
| <a name="input_cluster_security_group_additional_rules"></a> [cluster\_security\_group\_additional\_rules](#input\_cluster\_security\_group\_additional\_rules) | List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source | `any` | <pre>{<br>  "egress_nodes_ephemeral_ports_tcp": {<br>    "description": "Node all egress",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "source_node_security_group": true,<br>    "to_port": 0,<br>    "type": "egress"<br>  }<br>}</pre> | no |
| <a name="input_cluster_single_az"></a> [cluster\_single\_az](#input\_cluster\_single\_az) | Spin up the cluster in a single AZ | `bool` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Cluster Kubernetes Version | `string` | n/a | yes |
| <a name="input_eks_desired_nodes"></a> [eks\_desired\_nodes](#input\_eks\_desired\_nodes) | The initial starting number of nodes, per AZ if 'cluster\_single\_az' is false | `string` | `2` | no |
| <a name="input_eks_maximum_nodes"></a> [eks\_maximum\_nodes](#input\_eks\_maximum\_nodes) | The maximum number of nodes in the cluster, per AZ if 'cluster\_single\_az' is false | `string` | `3` | no |
| <a name="input_eks_minimum_nodes"></a> [eks\_minimum\_nodes](#input\_eks\_minimum\_nodes) | The minimum number of nodes in the cluster, per AZ if 'cluster\_single\_az' is false | `string` | `1` | no |
| <a name="input_eks_node_size"></a> [eks\_node\_size](#input\_eks\_node\_size) | Configure desired no of nodes for the cluster | `string` | `"t3.small"` | no |
| <a name="input_eks_node_tenancy"></a> [eks\_node\_tenancy](#input\_eks\_node\_tenancy) | The tenancy of the node instance to use for EKS | `string` | `"default"` | no |
| <a name="input_eks_node_type"></a> [eks\_node\_type](#input\_eks\_node\_type) | The type of nodes to use for EKS | `string` | `"ON_DEMAND"` | no |
| <a name="input_enable_cis_bootstrap"></a> [enable\_cis\_bootstrap](#input\_enable\_cis\_bootstrap) | Set to true to enable the CIS Boostrap, false to disable. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of infrastructure tags. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to use for the Cluster and resources | `string` | n/a | yes |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | The VPC Private Subnets to place EKS nodes into | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_general_eks_roles"></a> [aws\_general\_eks\_roles](#output\_aws\_general\_eks\_roles) | The EKS General Role ARNs |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | base64 encoded certificate data required to communicate with your cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for EKS control plane. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS cluster ID. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider |
| <a name="output_cluster_oidc_provider"></a> [cluster\_oidc\_provider](#output\_cluster\_oidc\_provider) | OpenID Connect identity provider without leading http |
| <a name="output_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#output\_cluster\_oidc\_provider\_arn) | OpenID Connect identity provider ARN |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group ids attached to the cluster control plane. |
| <a name="output_config_map_aws_auth"></a> [config\_map\_aws\_auth](#output\_config\_map\_aws\_auth) | A kubernetes configuration to authenticate to this EKS cluster. |
| <a name="output_region"></a> [region](#output\_region) | AWS region |
<!-- END_TF_DOCS -->
