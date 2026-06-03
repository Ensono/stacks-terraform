## Context

Terraform module testing in `stacks-terraform` is currently inconsistent and ungated. The `azurerm-aks` suite is the most developed example, yet before recent edits it relied on `terraform apply` tests that asserted only `if err == nil`, so they passed without assertions whenever Azure credentials were absent. The recent rewrite improved this (real `init`/`validate` and a plan-based precondition test) but also introduced brittle source-string assertions and a Go re-implementation of a precondition.

Critically, the PR pipeline ([build/azdo/azuredevops-runner.yml](../../../build/azdo/azuredevops-runner.yml)) runs only `eirctl format` (terraform fmt). There is no `go test` or `terraform validate` gate, and there are no `.github/workflows`. Tasks are orchestrated via `eirctl` ([eirctl.yaml](../../../eirctl.yaml), [build/eirctl/tasks.yaml](../../../build/eirctl/tasks.yaml)) using a PowerShell context. The build agent already has `terraform`; `go` availability on the agent must be confirmed or installed.

Constraints:

- The repo is a multi-cloud module library (`aws/`, `azurerm/`, `google/`), so the standard must be cloud-agnostic.
- Existing tests are Go/Terratest based; Terraform 1.6+ also offers the native `terraform test` framework.
- Conventions are governed by [AGENTS.md](../../../AGENTS.md): behaviour-preserving refactors, conventional signed commits, `tf fmt`/Prettier formatting.

## Goals / Non-Goals

**Goals:**

- A clear, cloud-agnostic three-tier testing standard (static / contract / live).
- The fast tier (static + contract) gated on every PR and runnable with one local command.
- Live tests opt-in via a single documented variable, with guaranteed cleanup.
- Authoring rules that steer away from tautological source-grep and logic duplication.
- `azurerm-aks` migrated as the reference implementation, with its stale test README fixed.

**Non-Goals:**

- Rewriting every module's tests in this change (only the standard, the CI gate, and the `azurerm-aks` reference are in scope).
- Mandating 100% live e2e coverage or provisioning long-lived test infrastructure.
- Selecting a specific managed CI platform beyond the existing Azure DevOps + eirctl setup.
- Changing module behaviour; test/CI wiring only.

## Decisions

### Decision 1: Three tiers — static, contract, live

Static = `fmt -check`, `init -backend=false`, `validate`, optional `tflint`/security scan. Contract = `terraform plan`/`terraform test` against local fixtures to assert preconditions, variable defaults/types, and output wiring offline. Live = real `apply`/`destroy`, opt-in only.

- **Why:** Maps cost/credentials to feedback speed; the fast tiers catch the majority of regressions deterministically and for free.
- **Alternatives considered:** Single "just run terratest apply" tier (rejected — slow, costly, credential-dependent, the current false-confidence trap); static-only (rejected — misses precondition/wiring behaviour).

### Decision 2: Prefer native `terraform test` for contract tier, keep Go for orchestration

New contract tests SHOULD use `terraform test` (`.tftest.hcl`) with `command = plan` and `expect_failures` for preconditions; Go/Terratest remains acceptable for live orchestration and existing suites.

- **Why:** `terraform test` runs plan-level assertions natively, removing the need for source-string grepping and Go re-implementation of HCL logic. It expresses intent against the real configuration.
- **Alternatives considered:** Continue Go-only with `terraform-exec`/string assertions (rejected — brittle, tautological); adopt `terratest` plan structs everywhere (viable but heavier and still Go-coupled).

### Decision 3: Gate the fast tier in CI via a new eirctl task + AzDO stage

Add `terraform:test` (or `test:fast`) to [build/eirctl/tasks.yaml](../../../build/eirctl/tasks.yaml) and a `Test` job in the Build stage that runs it on PRs, failing the build on error. Module discovery iterates module dirs containing a `test/` or `*.tftest.hcl`.

- **Why:** Reuses existing orchestration; makes the standard enforceable rather than aspirational.
- **Alternatives considered:** GitHub Actions workflow (rejected for now — repo gates via Azure DevOps; revisit if mirrored to GH). Per-module manual runs (rejected — that is the status quo gap).

### Decision 4: Single opt-in variable and deterministic auth skip

Standardise on one env var (e.g. `TF_RUN_LIVE_TESTS=1`) to enable live tests, plus a shared helper that skips (not passes) when credentials are absent.

- **Why:** Removes the ambiguity of per-module flags; prevents credential-absent false passes.
- **Alternatives considered:** Per-feature flags like `AKS_RUN_LIVE_TESTS` (rejected — proliferates and is inconsistent across modules).

## Risks / Trade-offs

- **`go` not present on the AzDO agent** → Confirm agent image; add a setup step (or containerised context) to install Go pinned to the module `go.mod` version before the test stage.
- **Turning on a real gate surfaces pre-existing failures across modules** → Roll out gate in warn/non-blocking mode first, fix offenders, then flip to required; or scope the gate to changed modules initially.
- **`terraform validate` requires provider download** → Allow provider install in the static tier but keep `-backend=false`; cache providers in CI to control time.
- **Migrating from Terratest to `terraform test` is unfamiliar to contributors** → Provide the `azurerm-aks` reference and a short authoring guide; keep Go acceptable so adoption is incremental.
- **CI minutes / plan time increase** → Scope fast tier to affected modules per PR via path filtering; reserve full-matrix runs for `main`.

## Migration Plan

1. Land the standard (this spec) and the `eirctl` fast-tier task.
2. Add the AzDO `Test` job in non-blocking mode; fix any modules that fail static/contract.
3. Migrate `azurerm-aks` to the standard: replace source-grep/tautological tests with `terraform test` contract checks, keep `init`/`validate`, gate live apply behind the standard variable, and correct `test/README.md`.
4. Flip the CI gate to required once the affected modules are green.
5. Document the standard in repo conventions for new modules.

Rollback: the gate is additive — reverting the eirctl task and AzDO job restores prior behaviour without affecting module code.

## Open Questions

- Is `go` available on the current AzDO agent image, or must we install/containerise it?
- Should the security scan (`checkov`/`trivy`) and `tflint` be mandatory in the static tier now, or introduced as a follow-up to avoid a large initial failure surface?
- Do we scope the PR gate to changed modules only, or run the full module matrix on every PR?
