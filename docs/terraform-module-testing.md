# Terraform Module Testing Standard

This standard defines how Terraform modules in `stacks-terraform` are tested. It
applies to every module under `aws/modules/**`, `azurerm/modules/**`, and
`google/modules/**`. The reference implementation is
[`azurerm/modules/azurerm-aks`](../azurerm/modules/azurerm-aks/test).

## Goals

- Catch the majority of module regressions on every pull request, deterministically
  and without cloud credentials.
- Reserve slow, costly, credential-dependent `apply` tests for explicit opt-in.
- Keep tests behavioural — asserting against real Terraform behaviour rather than
  source text or re-implemented logic.

## The three tiers

Every test file or test case MUST belong to exactly one tier and MUST be runnable
in isolation by tier. The **static** and **contract** tiers (together, the "fast
tier") MUST NOT require cloud credentials or create billable resources.

### 1. Static

Validates the configuration without planning real resources.

- `terraform fmt -check`
- `terraform init -backend=false`
- `terraform validate`
- Optional: `tflint` and a security scanner — see [Linting and security scanning](#linting-and-security-scanning).

### 2. Contract

Exercises module behaviour offline through `terraform plan` / `terraform test`
against local fixtures. Use native `terraform test` (`.tftest.hcl`) with
`command = plan` and **mocked providers** (`mock_provider`) so the tier runs with
no credentials and creates nothing.

The contract tier MUST cover:

- Variable defaults and types that affect behaviour.
- Resource wiring (that a variable flows through to the resource attribute).
- Output wiring.
- Preconditions / validation rules, asserted with `expect_failures`.

### 3. Live

Performs a real `terraform apply` / `destroy` against a cloud provider. Live tests
are **opt-in only** (see below) and MUST register a deferred `destroy` so resources
are cleaned up even on failure.

## Opt-in for live tests

Live tests are gated behind a single, repository-wide environment variable:

```bash
export TF_RUN_LIVE_TESTS=1
```

- When `TF_RUN_LIVE_TESTS` is **not** `1`, every live test is **skipped** with a
  message explaining how to enable it.
- When live tests are requested but cloud authentication is **absent**, the test is
  **skipped** — never passed. A credential-absent run must never produce a false
  pass.

For Azure, authentication is detected from `ARM_*` service-principal variables
(including OIDC) or an `az login` session; the shared `requireAzureAuthContext`
helper in the reference suite implements this skip-not-pass behaviour.

## Authoring rules

- **Assert behaviour, not source text.** Verify through `terraform validate`,
  `terraform plan`, or `terraform test`. Do **not** assert correctness by
  string-matching the contents of `.tf` files.
- **No logic duplication.** Do **not** re-implement a module's conditional/validation
  logic in test code and then assert against that copy. Exercise the Terraform
  configuration instead (e.g. `expect_failures` on a precondition).
- **Live tests always clean up** via a deferred `destroy`.

## Requirements for new modules

Any newly added module MUST ship at least the **static** and **contract** tiers
before it can be merged, and its `test/` directory MUST document how to run each
tier. Test documentation MUST stay consistent with the tests that exist — no
documented test case may be missing, and no removed test may remain documented.

## Linting and security scanning

`tflint` and an IaC security scanner (`checkov` / `trivy`) are **recommended** but
are **not yet mandatory** in the static tier. They are deferred to a follow-up
change to avoid a large initial failure surface across the existing module library.
When adopted, they will be added to the static tier and the CI fast-tier task.

## CI gate

The fast tier (static + contract) runs for affected modules on every pull request
via the `eirctl` `test:fast` pipeline and the Azure DevOps Build stage. The build
fails when any fast-tier test fails. See
[`build/eirctl/tasks.yaml`](../build/eirctl/tasks.yaml) and
[`build/azdo/azuredevops-runner.yml`](../build/azdo/azuredevops-runner.yml).
