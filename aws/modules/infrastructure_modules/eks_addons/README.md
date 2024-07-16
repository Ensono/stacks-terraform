<!-- BEGIN_TF_DOCS -->

Terraform configuration files to enable Amazon Cloudwatch Container-Insights via EKS addon feature.

https://aws-observability.github.io/observability-best-practices/guides/containers/aws-native/eks/amazon-cloudwatch-container-insights/


## Requirements

To enable the observability feature in Amazon EKS, proper IAM role configuration is essential. This can be achieved through two main approaches:

Worker Node IAM Role:
You can set up a less-privileged IAM role on the worker nodes.
For a quicker setup, you can configure a privileged IAM role on the worker nodes using the following command. 
This can be run interactively or integrated into your main EKS infrastructure deployment:

```
aws iam attach-role-policy --role-name my-worker-node-role --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
```

IAM Roles for Service Accounts (IRSA):
This approach provides more fine-grained control over permissions at the pod level.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.amazon_cloudwatch_observability](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addon_resolve_conflicts_on_create"></a> [addon\_resolve\_conflicts\_on\_create](#input\_addon\_resolve\_conflicts\_on\_create) | Define how to resolve parameter value conflicts when creating the EKS add-on | `string` | `"OVERWRITE"` | no |
| <a name="input_addon_resolve_conflicts_on_update"></a> [addon\_resolve\_conflicts\_on\_update](#input\_addon\_resolve\_conflicts\_on\_update) | Define how to resolve parameter value conflicts when updating the EKS add-on | `string` | `"PRESERVE"` | no |
| <a name="input_addon_version"></a> [addon\_version](#input\_addon\_version) | Version of the amazon-cloudwatch-observability add-on | `string` | `"v1.8.0-eksbuild.1"` | no |
| <a name="input_cloudwatch_observability_enabled"></a> [cloudwatch\_observability\_enabled](#input\_cloudwatch\_observability\_enabled) | Whether to enable amazon cloudwatch observability | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_config"></a> [custom\_config](#input\_custom\_config) | Custom configuration for CloudWatch Agent | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_observability_addon_arn"></a> [cloudwatch\_observability\_addon\_arn](#output\_cloudwatch\_observability\_addon\_arn) | Status of the CloudWatch Observability EKS add-on |
<!-- END_TF_DOCS -->
