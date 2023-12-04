Provision an IRSA IAM Role
--------------------------

Terraform configuration files to create an IAM role for accessing AWS Services
via OIDC Provider (IRSA).

The module outputs the Role ARN as `irsa_role_arn`. This can be used to create
the Kubernetes Service accounts using Helm or YAML files and then annotated like
the following:
```yml
eks.amazonaws.com/role-arn: "{{ service_account_arn }}"
```
to assign the AWS Role to the Kubernetes Service Account.

**NOTE:** This module no longer handles the Service Account creation itself,
this 'has' to be done using Helm or YAML as a K8s deploy phase.

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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account id to configure irsa role | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of Kubernetes cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | EKS cluster OIDC url | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of Kubernetes namespace | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | Policy json to apply to the irsa role | `string` | n/a | yes |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | The path to put the policy under, if not null the cluster\_name will be used as the path | `string` | `null` | no |
| <a name="input_policy_prefix"></a> [policy\_prefix](#input\_policy\_prefix) | A prefix to use for the policies, which will be spliced with a dash. | `string` | `""` | no |
| <a name="input_resource_description"></a> [resource\_description](#input\_resource\_description) | The description to assign to the policy and role | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of Kubernetes service account | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_irsa_role_arn"></a> [irsa\_role\_arn](#output\_irsa\_role\_arn) | The ARN of IAM IRSA role created |
<!-- END_TF_DOCS -->
