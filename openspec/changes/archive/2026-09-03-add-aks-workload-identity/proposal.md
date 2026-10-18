# Add opt-in AKS Workload Identity support

## Summary

Add first-class Azure AKS Workload Identity support to the `azurerm/modules/azurerm-aks` Terraform module while keeping the feature disabled by default for conservative backward compatibility.

The module already exposes `oidc_issuer_enabled` and defaults it to `true`, but it does not expose `workload_identity_enabled` or the AKS OIDC issuer URL required by downstream `azurerm_federated_identity_credential` resources.

## Motivation

Downstream AKS infrastructure work needs Azure Workload Identity for controller integrations such as:

- cert-manager DNS-01 access to Azure DNS
- External Secrets Operator access to Azure Key Vault PushSecret workflows

Without module-level support, consumers must patch or fork the AKS module before they can create federated identity credentials against the cluster OIDC issuer.

## Proposed Change

Update `azurerm/modules/azurerm-aks` to:

- Add a `workload_identity_enabled` boolean input.
- Default `workload_identity_enabled` to `false` to avoid changing existing cluster behavior on module upgrade.
- Wire `workload_identity_enabled` into `azurerm_kubernetes_cluster.default`.
- Enforce that Workload Identity cannot be enabled when `oidc_issuer_enabled` is `false`.
- Output the AKS OIDC issuer URL for downstream federated identity credential creation.
- Output the resolved Workload Identity enabled state.
- Update README documentation and module tests.

## Non-goals

- Create managed identities for workloads.
- Create `azurerm_federated_identity_credential` resources.
- Manage Kubernetes service accounts, annotations, or Helm releases.
- Change the existing default for `oidc_issuer_enabled`.
- Enable Workload Identity by default.

## Compatibility

This change intentionally uses an opt-in default for `workload_identity_enabled`.

Existing consumers that upgrade the module without setting the new input should not have Workload Identity enabled implicitly. Consumers that need the feature can set:

```hcl
workload_identity_enabled = true
```

OIDC issuer support remains enabled by default through the existing `oidc_issuer_enabled = true` behavior.

## Success Criteria

- Module consumers can opt in to AKS Workload Identity without local patches.
- The module exposes the AKS OIDC issuer URL for downstream federated identity credential resources.
- Terraform fails early or clearly when `workload_identity_enabled = true` and `oidc_issuer_enabled = false` are combined.
- Existing consumers remain backward compatible by default.
- README inputs/outputs document the new feature and OIDC dependency.
- Tests cover the new input, outputs, resource wiring, default behavior, explicit enable/disable, and invalid configuration guard.
