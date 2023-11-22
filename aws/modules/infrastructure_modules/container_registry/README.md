AWS Container Registry
----------------------

A module for creating repositories and their policies, set up a Pull Through
Cache policy and repositories, and set up the security scanning policy.

**NOTE:** To ensure Kubernetes can pull Pull Through Cache images, ensure a
policy is set up and attached to the worker node role(s), like the following:
```tf
data "aws_iam_policy_document" "additional_eks" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchImportUpstreamImage",
    ]

    resources = [
      "arn:aws:ecr:<region>:<account_id>:repository/<pullthrough_cache_name_1>/*",
      "arn:aws:ecr:<region>:<account_id>:repository/<pullthrough_cache_name_2>/*",
    ]
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | > 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | terraform-aws-modules/ecr/aws | 1.6.0 |
| <a name="module_ecr_pull_through_cache"></a> [ecr\_pull\_through\_cache](#module\_ecr\_pull\_through\_cache) | terraform-aws-modules/ecr/aws | 1.6.0 |
| <a name="module_ecr_registry_scanning_rules"></a> [ecr\_registry\_scanning\_rules](#module\_ecr\_registry\_scanning\_rules) | terraform-aws-modules/ecr/aws | 1.6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.pull_through_allow_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_registry_scanning"></a> [enable\_registry\_scanning](#input\_enable\_registry\_scanning) | Whether to enable continuous registry scanning | `bool` | n/a | yes |
| <a name="input_max_tagged_image_count"></a> [max\_tagged\_image\_count](#input\_max\_tagged\_image\_count) | The maximum number of tagged images to keep for each repository | `number` | n/a | yes |
| <a name="input_max_untagged_image_count"></a> [max\_untagged\_image\_count](#input\_max\_untagged\_image\_count) | The maximum number of untagged images to keep for each repository | `number` | `1` | no |
| <a name="input_pull_accounts"></a> [pull\_accounts](#input\_pull\_accounts) | List of accounts that can pull | `list(string)` | n/a | yes |
| <a name="input_pull_and_push_accounts"></a> [pull\_and\_push\_accounts](#input\_pull\_and\_push\_accounts) | List of accounts that can pull and push | `list(string)` | n/a | yes |
| <a name="input_pull_through_cache_accounts"></a> [pull\_through\_cache\_accounts](#input\_pull\_through\_cache\_accounts) | A default list of accounts for the Pull Through Cache if not configured in the `pull_through_cache_setup`. Defaults to the calling account root | `list(string)` | `[]` | no |
| <a name="input_pull_through_cache_setup"></a> [pull\_through\_cache\_setup](#input\_pull\_through\_cache\_setup) | The set-up for the Pull Through Cache, an object like {ecr-public = {images = ["foo"] upstream\_registry\_url = "public.ecr.aws"}} | <pre>map(<br>      object({<br>      upstream_registry_url = string<br>      images
     = list(string)<br>      accounts              = optional(list(string))<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The name of the region to use | `string` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | A list of the repositories to create | `list(string)` | n/a | yes |
| <a name="input_repository_image_tag_mutability"></a> [repository\_image\_tag\_mutability](#input\_repository\_image\_tag\_mutability) | Whether the repositories are MUTABLE or IMMUTABLE. Best choice is IMMUTABLE | `string` | `"IMMUTABLE"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
