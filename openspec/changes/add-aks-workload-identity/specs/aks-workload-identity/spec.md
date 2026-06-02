## ADDED Requirements

### Requirement: Opt-in Workload Identity input

The `azurerm-aks` module SHALL expose a `workload_identity_enabled` boolean input that defaults to `false`, so that existing consumers are not implicitly opted into Azure Workload Identity when they upgrade the module. The input MUST be wired into the `azurerm_kubernetes_cluster.default` resource.

#### Scenario: Default keeps Workload Identity disabled

- **WHEN** a consumer creates the AKS cluster without setting `workload_identity_enabled`
- **THEN** the module plans the `azurerm_kubernetes_cluster` with `workload_identity_enabled = false`

#### Scenario: Explicitly enabling Workload Identity

- **WHEN** a consumer sets `workload_identity_enabled = true` with `oidc_issuer_enabled = true`
- **THEN** the module plans the `azurerm_kubernetes_cluster` with `workload_identity_enabled = true`

#### Scenario: Explicitly disabling Workload Identity

- **WHEN** a consumer sets `workload_identity_enabled = false`
- **THEN** the module plans the `azurerm_kubernetes_cluster` with `workload_identity_enabled = false`

### Requirement: Workload Identity requires the OIDC issuer

The module SHALL prevent enabling Workload Identity when the OIDC issuer is disabled. When `workload_identity_enabled = true` and `oidc_issuer_enabled = false`, Terraform MUST fail with a clear error rather than producing a cluster configuration that cannot support federated identity.

#### Scenario: Invalid combination fails planning

- **WHEN** a consumer sets `workload_identity_enabled = true` and `oidc_issuer_enabled = false`
- **THEN** `terraform plan` fails with a precondition error stating that `workload_identity_enabled` requires `oidc_issuer_enabled` to be true

#### Scenario: OIDC enabled with Workload Identity disabled is allowed

- **WHEN** a consumer sets `oidc_issuer_enabled = true` and `workload_identity_enabled = false`
- **THEN** the configuration is valid and plans without a precondition error

### Requirement: Cluster identity outputs for downstream federation

The module SHALL expose the cluster OIDC issuer URL and the resolved Workload Identity state as outputs, so that downstream `azurerm_federated_identity_credential` resources can reference the cluster. The outputs MUST follow the existing `create_aks` conditional style.

#### Scenario: Outputs available when the cluster is created

- **WHEN** the AKS cluster is created (`create_aks = true`)
- **THEN** the module exposes `aks_oidc_issuer_url` from `azurerm_kubernetes_cluster.default.0.oidc_issuer_url`
- **AND** the module exposes `aks_workload_identity_enabled` reflecting the configured Workload Identity state

#### Scenario: Outputs are inert when the cluster is not created

- **WHEN** the cluster is not created (`create_aks = false`)
- **THEN** `aks_oidc_issuer_url` returns an empty string
- **AND** `aks_workload_identity_enabled` returns `false`

### Requirement: Workload Identity feature is documented

The module README SHALL document the `workload_identity_enabled` input, the `aks_oidc_issuer_url` and `aks_workload_identity_enabled` outputs, and the requirement that Workload Identity depends on the OIDC issuer being enabled.

#### Scenario: README documents inputs, outputs, and dependency

- **WHEN** a contributor reads `azurerm/modules/azurerm-aks/README.md`
- **THEN** the inputs table lists `workload_identity_enabled` with its default of `false`
- **AND** the outputs table lists `aks_oidc_issuer_url` and `aks_workload_identity_enabled`
- **AND** the documentation states that `workload_identity_enabled = true` requires `oidc_issuer_enabled = true`
