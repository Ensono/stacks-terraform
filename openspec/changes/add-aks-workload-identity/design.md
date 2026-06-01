# Design: opt-in AKS Workload Identity support

## Context

The AKS module currently creates an `azurerm_kubernetes_cluster.default` resource and already passes `oidc_issuer_enabled = var.oidc_issuer_enabled`. The OIDC issuer input defaults to `true` and is documented as supporting workload identity federation.

Azure AKS Workload Identity requires the cluster OIDC issuer to be enabled. Downstream modules or stacks then use the cluster OIDC issuer URL when creating Azure federated identity credentials.

## Design Overview

Add cluster-level Workload Identity support only:

```text
azurerm-aks module
  ├─ oidc_issuer_enabled       existing, default true
  ├─ workload_identity_enabled new, default false
  ├─ aks_oidc_issuer_url       new output
  └─ aks_workload_identity_enabled new output

Downstream stack
  ├─ managed identity
  ├─ federated identity credential
  ├─ Kubernetes service account annotation
  └─ Helm/controller configuration
```

The AKS module remains responsible for the cluster feature flags and exposing cluster metadata. Workload-specific identities remain outside this module.

## Module API

### New input

`workload_identity_enabled`

- Type: `bool`
- Default: `false`
- Description: enable Azure Workload Identity on the AKS cluster. Requires `oidc_issuer_enabled = true`.

The default is intentionally `false` to avoid implicit enablement for existing consumers.

### New outputs

`aks_oidc_issuer_url`

- Returns `azurerm_kubernetes_cluster.default.0.oidc_issuer_url` when AKS is created.
- Returns an empty string when `create_aks = false`, matching existing conditional output style.
- Used by downstream `azurerm_federated_identity_credential` resources.

`aks_workload_identity_enabled`

- Returns the configured Workload Identity enabled state when AKS is created.
- Returns `false` when `create_aks = false`.

## Resource Wiring

Update `azurerm_kubernetes_cluster.default`:

```hcl
oidc_issuer_enabled       = var.oidc_issuer_enabled
workload_identity_enabled = var.workload_identity_enabled
```

## Validation Strategy

The invalid combination is:

```text
workload_identity_enabled = true
oidc_issuer_enabled       = false
```

Prefer a hard validation that blocks planning/apply. A lifecycle `precondition` on `azurerm_kubernetes_cluster.default` is the clearest fit because it can reference multiple variables and fail near the affected resource.

The condition should allow:

| OIDC  | Workload Identity | Valid |
|-------|-------------------|-------|
| true  | true              | yes   |
| true  | false             | yes   |
| false | false             | yes   |
| false | true              | no    |

## Testing Approach

Use fast tests where possible because live AKS apply tests are expensive and environment-dependent.

Recommended tests:

- Static test: `variables.tf` includes `workload_identity_enabled` as a bool with default `false`.
- Static test: `aks.tf` wires `workload_identity_enabled = var.workload_identity_enabled`.
- Static test: `outputs.tf` includes `aks_oidc_issuer_url` and `aks_workload_identity_enabled`.
- Validation/plan test: explicit `workload_identity_enabled = true` with `oidc_issuer_enabled = true` is valid.
- Validation/plan test: explicit `workload_identity_enabled = false` is valid.
- Negative test: `workload_identity_enabled = true` with `oidc_issuer_enabled = false` fails with a clear error.
- README test or static assertion: docs include new input/output and OIDC dependency language.

Existing OIDC tests may be extended or a new `workload_identity_test.go` may be added. Prefer deterministic tests over tests that pass even when live `terraform apply` fails.

## Documentation

Update `azurerm/modules/azurerm-aks/README.md` to include:

- New input row for `workload_identity_enabled`.
- New output rows for `aks_oidc_issuer_url` and `aks_workload_identity_enabled`.
- A short note that Workload Identity requires OIDC issuer support.
- Example usage:

```hcl
oidc_issuer_enabled       = true
workload_identity_enabled = true
```

## Risks and Mitigations

| Risk                                                      | Mitigation                                     |
|-----------------------------------------------------------|------------------------------------------------|
| Existing consumers get unexpected cluster feature changes | Default Workload Identity to `false`           |
| Consumers enable Workload Identity but disable OIDC       | Add hard validation/precondition               |
| Output references fail when `create_aks = false`          | Match existing conditional output pattern      |
| Tests become slow/flaky due live AKS provisioning         | Prefer static and validation/plan tests        |
| Responsibility creep into federated credentials           | Keep downstream identities out of module scope |

## Open Question

Should downstream examples be updated to demonstrate federated identity credential creation, or should this change keep examples limited to the AKS module feature flags? The conservative recommendation is to keep examples scoped to this module unless a downstream integration example already exists.
