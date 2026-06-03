# AKS Module Tests

This directory contains the automated tests for the Azure Kubernetes Service
(AKS) Terraform module. The tests follow the repository
[Terraform module testing standard](../../../../docs/terraform-module-testing.md)
and are organised into three tiers: **static**, **contract**, and **live**.

## Test tiers

### Static tier (`terraform_execution_test.go`)

- **TestModuleInitAndValidate** — runs `terraform init -backend=false` and
  `terraform validate` for the module. Requires no cloud credentials and
  creates no resources.

### Contract tier (`../tests/*.tftest.hcl`)

Native `terraform test` files that run `terraform plan` with mocked providers,
so they execute fully offline and create no billable resources:

- **contract.tftest.hcl** — asserts that `oidc_issuer_enabled` and
  `workload_identity_enabled` wire through to the cluster resource and the
  `aks_workload_identity_enabled` output for both default and enabled
  configurations. It also asserts that default node pool `upgrade_settings`
  explicitly model AzureRM v4 defaults so consecutive plans do not drift after
  Azure reports those defaults back.
- **precondition.tftest.hcl** — uses `expect_failures` to assert that enabling
  workload identity without the OIDC issuer fails the module precondition.

### Live tier (`live_test.go`)

- **TestExampleApplyWhenLiveTestsEnabled** — performs a real `terraform apply`
  of the `entire-infra` example and always registers a deferred `destroy`.
  Skipped unless the opt-in variable is set (see below).

## Prerequisites

- Terraform >= 1.7 (for `mock_provider` support in `terraform test`)
- Go >= 1.21

## Running the tests

### Fast tier (static + contract, no credentials required)

```bash
# Static tier
cd test
go test ./...

# Contract tier
cd ..
terraform init -backend=false
terraform test
```

The repository `eirctl` task runs the same fast-tier checks:

```bash
eirctl test:fast
```

### Live tier (opt-in, incurs cloud cost)

Live tests are skipped by default. Enable them with the single, repository-wide
opt-in variable and valid Azure authentication:

```bash
export TF_RUN_LIVE_TESTS=1
# plus Azure auth, e.g. `az login` or ARM_* service-principal variables
cd test
go test ./... -run TestExampleApplyWhenLiveTestsEnabled -timeout 60m
```

If `TF_RUN_LIVE_TESTS` is unset, or Azure authentication is absent, the live
test is **skipped** (never a false pass).

## Authoring rules

- Assert behaviour through `terraform validate`, `terraform plan`, or
  `terraform test` — never by string-matching `.tf` source files.
- Do not re-implement module logic in test code and assert against the copy.
- Live tests must guarantee cleanup via a deferred `destroy`.

## References

- [Terraform module testing standard](../../../../docs/terraform-module-testing.md)
- [terraform test command](https://developer.hashicorp.com/terraform/language/tests)
- [OIDC Issuer in Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/use-oidc-issuer)
