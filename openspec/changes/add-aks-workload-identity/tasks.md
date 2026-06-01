# Tasks

## 1. Module input and resource wiring

- [ ] 1.1 Add `workload_identity_enabled` to `azurerm/modules/azurerm-aks/variables.tf` with type `bool`, default `false`, and documentation that OIDC issuer is required.
- [ ] 1.2 Wire `workload_identity_enabled = var.workload_identity_enabled` into `azurerm_kubernetes_cluster.default` in `aks.tf`.
- [ ] 1.3 Add a hard validation/precondition so `workload_identity_enabled = true` cannot be used with `oidc_issuer_enabled = false`.

## 2. Outputs

- [ ] 2.1 Add `aks_oidc_issuer_url` output for the cluster OIDC issuer URL.
- [ ] 2.2 Add `aks_workload_identity_enabled` output for the configured Workload Identity state.
- [ ] 2.3 Ensure outputs follow existing `create_aks` conditional style where needed.

## 3. Tests

- [ ] 3.1 Add or update Terratest/static tests to verify the `workload_identity_enabled` variable exists, is boolean, and defaults to `false`.
- [ ] 3.2 Add or update tests to verify `aks.tf` wires the new variable into `azurerm_kubernetes_cluster.default`.
- [ ] 3.3 Add or update tests to verify the new OIDC issuer URL and Workload Identity outputs exist.
- [ ] 3.4 Add or update tests for explicit enable and explicit disable configurations.
- [ ] 3.5 Add a negative test for `workload_identity_enabled = true` with `oidc_issuer_enabled = false`.
- [ ] 3.6 Run relevant module tests from `azurerm/modules/azurerm-aks/test`.

## 4. Documentation

- [ ] 4.1 Update `azurerm/modules/azurerm-aks/README.md` inputs table with `workload_identity_enabled`.
- [ ] 4.2 Update README outputs table with `aks_oidc_issuer_url` and `aks_workload_identity_enabled`.
- [ ] 4.3 Add a short README note or example showing `oidc_issuer_enabled = true` with `workload_identity_enabled = true`.

## 5. Validation

- [ ] 5.1 Run Terraform formatting for the AKS module.
- [ ] 5.2 Run Terraform validation for the AKS module or example as appropriate.
- [ ] 5.3 Confirm `openspec status --change add-aks-workload-identity` reports the change is ready for implementation.
