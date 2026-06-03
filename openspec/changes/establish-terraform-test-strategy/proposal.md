## Why

Terraform module tests in this repo are written ad hoc, are not gated by CI, and lean heavily on brittle source-string assertions and false-confidence `apply` tests that assert nothing when cloud credentials are absent. The PR pipeline runs only `terraform fmt`, so module regressions (broken `validate`, broken preconditions, drifted variables/outputs) can merge unnoticed. We need a consistent, enterprise-grade testing standard that runs fast checks on every PR and reserves costly live tests for opt-in execution.

## What Changes

- Define a tiered testing standard for all Terraform modules: **static** (fmt, validate, lint, security scan), **contract/plan** (preconditions, variable/output wiring via `terraform plan` against fixtures), and **opt-in live** (real `apply`/`destroy`, explicitly gated).
- Add a repository convention that every module's fast tier (`fmt` + `init -backend=false` + `validate` + plan-based contract tests) MUST run on every PR as a required gate.
- Add an `eirctl` task and a CI stage that discovers modules and runs the fast test tier, failing the build on any error. **BREAKING** for CI: PRs that previously passed with only a format check may now fail on `validate`/contract errors.
- Establish authoring rules that discourage tautological source-grep assertions and logic re-implemented in test code, and prefer behaviour verified through `terraform validate`/`plan`.
- Standardise how live tests are gated (single documented env var) and how Azure auth is detected/skipped, so suites are deterministic offline.
- Retrofit the `azurerm-aks` test suite to the new standard as the reference implementation and remove the stale `test/README.md` drift.

## Capabilities

### New Capabilities

- `terraform-module-testing`: Defines the required test tiers for Terraform modules, what each tier must cover, how fast tests are gated in CI, how live tests are opted into, and the authoring rules that keep tests behavioural rather than tautological.

### Modified Capabilities

<!-- No existing specs in openspec/specs/; nothing to modify. -->

## Impact

- **CI/build**: `eirctl.yaml`, `build/eirctl/tasks.yaml`, `build/eirctl/contexts.yaml`, and `build/azdo/azuredevops-runner.yml` gain a test task and a PR-time test stage. Requires `go` and `terraform` available on the build agent.
- **Module tests**: Test files under `*/modules/*/test/` (Go/Terratest and native `terraform test`) are expected to conform to the tiered standard; `azurerm-aks` is migrated first.
- **Tooling**: Optionally introduces `tflint` and a security scanner (e.g. `checkov`/`trivy`) into the static tier; these become build dependencies if adopted.
- **Contributors**: New modules must ship at least the static + contract tiers; documented in repo conventions.
