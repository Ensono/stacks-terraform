# Provision an IRSA 


Terraform configuration files to create IRSA for accessing AWS Services Via OIDC Provider.


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_namespace.ns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_iam_policy_document.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account id to configure irsa role | `string` | `""` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | Name of Kubernetes cluster | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Enables creating the namespace | `bool` | `false` | no |
| <a name="input_create_serviceaccount"></a> [create\_serviceaccount](#input\_create\_serviceaccount) | Enables creating a serviceaccount | `bool` | `false` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Add irsa role for the serviceaccount | `bool` | `false` | no |
| <a name="input_issuer_url"></a> [issuer\_url](#input\_issuer\_url) | EKS cluster OIDC url | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of Kubernetes namespace | `any` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | Policy json to apply to the irsa role | `string` | `""` | no |
| <a name="input_serviceaccount"></a> [serviceaccount](#input\_serviceaccount) | Name of Kubernetes serviceaccount | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_irsa_role"></a> [irsa\_role](#output\_irsa\_role) | The name of finegrained IAM role created |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The name of the related namespace |
| <a name="output_serviceaccount"></a> [serviceaccount](#output\_serviceaccount) | The name of the related serviceaccount |
<!-- END_TF_DOCS -->