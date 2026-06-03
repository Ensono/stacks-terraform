# Azure Application Gateway Module

This module provisions an Azure Application Gateway with HTTP and HTTPS
listeners in front of an existing ingress endpoint. It now supports three
certificate source modes:

- `key_vault`: reference a versionless Azure Key Vault secret or certificate URI for automatic rotation
- `acme`: preserve the existing ACME DNS-01 flow and inline PFX upload behavior
- `self_signed`: preserve the existing self-signed fallback path

When `certificate_source` is not set, the module keeps backward-compatible behavior by deriving the mode from `create_valid_cert`:

- `create_valid_cert = true` -> `acme`
- `create_valid_cert = false` -> `self_signed`

If Let's Encrypt has deactivated the ACME account previously used by this module,
set `acme_account_key_rotation_token` to a new value before re-enabling
`create_valid_cert`. Changing the token forces Terraform to generate a new ACME
account key and registration without manual state edits. Use only a short
non-secret value such as a date or nonce, because this token will be stored in
Terraform state and may appear in resource instance keys.

## Requirements

| Name      | Version  |
| --------- | -------- |
| Terraform | `>= 1.3` |

## New and updated inputs

| Input                             | Type           | Default       | Notes                                                                                                                                                               |
| --------------------------------- | -------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `certificate_source`              | `string`       | `null`        | Explicit certificate mode. Allowed values are `key_vault`, `acme`, and `self_signed`. When omitted, the module preserves legacy behavior using `create_valid_cert`. |
| `key_vault_secret_id`             | `string`       | `null`        | Versionless Key Vault secret or certificate URI used when `certificate_source = "key_vault"`.                                                                       |
| `identity_type`                   | `string`       | `null`        | Managed identity type for Application Gateway. The module currently accepts `UserAssigned`.                                                                         |
| `user_assigned_identity_ids`      | `list(string)` | `[]`          | User-assigned managed identity resource IDs attached when `identity_type = "UserAssigned"`.                                                                         |
| `create_valid_cert`               | `bool`         | `true`        | Deprecated legacy selector. Still used when `certificate_source` is unset.                                                                                          |
| `create_ssl_cert`                 | `bool`         | `true`        | Deprecated compatibility flag. Retained to avoid breaking existing consumers.                                                                                       |
| `pfx_password`                    | `string`       | `"Password1"` | Used only for `acme` and `self_signed` modes. Ignored for `key_vault`.                                                                                              |
| `acme_email`                      | `string`       | `null`        | Required only when the effective certificate source is `acme`.                                                                                                      |
| `acme_account_key_rotation_token` | `string`       | `null`        | Optional non-sensitive token used only in `acme` mode to force recreation of the ACME account key and registration.                                                 |

The rest of the networking, probe, and naming inputs are unchanged.

## Validation behavior

The module now fails early when configuration is invalid:

- `certificate_source = "key_vault"` requires `key_vault_secret_id`
- `certificate_source = "key_vault"` requires `identity_type = "UserAssigned"`
- `identity_type = "UserAssigned"` requires at least one value in `user_assigned_identity_ids`
- `certificate_source = "acme"` requires `acme_email`
- `key_vault_secret_id` must be a versionless Key Vault secret or certificate URI

## Legacy ACME example

See `examples/appgateway` for a minimal legacy-compatible ACME configuration.

```hcl
module "legacy_acme_app_gateway" {
  source = "../../"

  resource_namer          = "example-appgw-acme"
  resource_group_name     = "rg-example-network"
  resource_group_location = "uksouth"

  vnet_name                 = "vnet-example-network"
  vnet_cidr                 = ["10.10.0.0/16"]
  subnet_front_end_prefix   = "10.10.0.0/24"
  subnet_backend_end_prefix = "10.10.1.0/24"

  dns_zone              = "apps.example.invalid"
  dns_resource_group    = "rg-example-dns"
  azure_subscription_id = "00000000-0000-0000-0000-000000000000"
  acme_email            = "platform@example.invalid"
  pfx_password          = "Password1"

  aks_resource_group = "rg-example-aks"
  aks_ingress_ip     = "10.10.1.4"
}
```

## Key Vault example

See `examples/appgateway-entire` for a minimal Key Vault-backed configuration.

```hcl
module "key_vault_app_gateway" {
  source = "../../"

  resource_namer          = "example-appgw-kv"
  resource_group_name     = "rg-example-network"
  resource_group_location = "uksouth"

  vnet_name                 = "vnet-example-network"
  vnet_cidr                 = ["10.20.0.0/16"]
  subnet_front_end_prefix   = "10.20.0.0/24"
  subnet_backend_end_prefix = "10.20.1.0/24"

  dns_zone = "apps.example.invalid"

  aks_resource_group = "rg-example-aks"
  aks_ingress_ip     = "10.20.1.4"

  certificate_source         = "key_vault"
  key_vault_secret_id        = "https://example-kv.vault.azure.net/secrets/app-gateway-tls"
  identity_type              = "UserAssigned"
  user_assigned_identity_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example-identity/providers/Microsoft.ManagedIdentity/userAssignedIdentities/app-gateway-kv-reader"
  ]
}
```

## Migration from ACME or self-signed to Key Vault

1. Create or identify a user-assigned managed identity for Application Gateway.
2. Grant that identity permission to read the certificate secret from Key Vault. The module does not manage Key Vault RBAC.
3. Import or issue the TLS certificate into Azure Key Vault and use a versionless secret URI.
4. Update the module call to set:
    - `certificate_source = "key_vault"`
    - `key_vault_secret_id = "https://<vault>.vault.azure.net/secrets/<certificate-name>"`
    - `identity_type = "UserAssigned"`
    - `user_assigned_identity_ids = ["<resource-id>"]`
5. Remove `acme_email` and any downstream ACME-specific automation once the new path is deployed and verified.

## Rotation and RBAC notes

- Use a versionless Key Vault secret URI so Application Gateway can pick up certificate rotations without changing module input values.
- Consumers are responsible for assigning the correct Key Vault RBAC role or access policy outside this module.
- Application Gateway must be able to read the Key Vault secret material backing the certificate.

## Outputs for downstream consumers

The module now exposes outputs needed for migration and RBAC wiring:

- `effective_certificate_source`
- `effective_key_vault_secret_id`
- `app_gateway_identity`
- `app_gateway_identity_principal_id`
- `app_gateway_identity_tenant_id`
- `app_gateway_identity_type`
- `app_gateway_user_assigned_identity_ids`

For `acme` and `self_signed` modes, `certificate_pem` and `issuer_pem`
remain available. In `key_vault` mode those outputs are `null` because
certificate material is no longer uploaded inline.
