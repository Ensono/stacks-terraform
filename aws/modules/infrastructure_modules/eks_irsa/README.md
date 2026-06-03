# Provision an IRSA IAM Role

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

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.3  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 5.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 5.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                       | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                            | resource    |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                  | resource    |
| [aws_iam_role_policy_attachment.additional_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)            | resource    |
| [aws_iam_policy.additional_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy)                            | data source |
| [aws_iam_policy_document.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                         | data source |

## Inputs

| Name                                                                                                                              | Description                                                                                     | Type          | Default | Required |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------- | ------- | :------: |
| <a name="input_additional_policies"></a> [additional_policies](#input_additional_policies)                                        | A set of pre-exisiting AWS Policies to apply to the IRSA role, e.g. CloudWatchAgentServerPolicy | `set(string)` | n/a     |   yes    |
| <a name="input_additional_service_account_names"></a> [additional_service_account_names](#input_additional_service_account_names) | Addiotional Service Accounts allowed to assume this role                                        | `set(string)` | n/a     |   yes    |
| <a name="input_aws_account_id"></a> [aws_account_id](#input_aws_account_id)                                                       | AWS account id to configure irsa role                                                           | `string`      | n/a     |   yes    |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name)                                                             | Name of Kubernetes cluster                                                                      | `string`      | n/a     |   yes    |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster_oidc_issuer_url](#input_cluster_oidc_issuer_url)                            | EKS cluster OIDC url                                                                            | `string`      | n/a     |   yes    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                                                                      | Name of Kubernetes namespace                                                                    | `string`      | n/a     |   yes    |
| <a name="input_policy"></a> [policy](#input_policy)                                                                               | Policy json to apply to the irsa role                                                           | `string`      | `""`    |    no    |
| <a name="input_policy_path"></a> [policy_path](#input_policy_path)                                                                | The path to put the policy under, if not null the cluster_name will be used as the path         | `string`      | `null`  |    no    |
| <a name="input_policy_prefix"></a> [policy_prefix](#input_policy_prefix)                                                          | A prefix to use for the policies, which will be spliced with a dash.                            | `string`      | `""`    |    no    |
| <a name="input_resource_description"></a> [resource_description](#input_resource_description)                                     | The description to assign to the policy and role                                                | `string`      | `""`    |    no    |
| <a name="input_service_account_name"></a> [service_account_name](#input_service_account_name)                                     | Name of Kubernetes Service Account                                                              | `string`      | n/a     |   yes    |

## Outputs

| Name                                                                       | Description                      |
| -------------------------------------------------------------------------- | -------------------------------- |
| <a name="output_irsa_role_arn"></a> [irsa_role_arn](#output_irsa_role_arn) | The ARN of IAM IRSA role created |

<!-- END_TF_DOCS -->
