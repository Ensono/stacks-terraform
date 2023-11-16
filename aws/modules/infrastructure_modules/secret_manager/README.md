## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.sec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.secver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `30` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of secrets to keep in AWS Secrets Manager | `any` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | User-Defined tags. | `any` | `{}` | no |
| <a name="input_unmanaged"></a> [unmanaged](#input\_unmanaged) | Terraform must ignore secrets lifecycle. Using this option you can initialize the secrets and rotate them outside Terraform, thus, avoiding other users to change or rotate the secrets by subsequent runs of Terraform | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Secret arn list |
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | Secret id list |