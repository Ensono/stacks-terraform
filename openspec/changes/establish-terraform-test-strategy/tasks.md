## 1. Define and document the testing standard

- [x] 1.1 Write a `docs/` (AsciiDoc) or repo-convention page describing the three tiers (static, contract, live), what each MUST cover, and the authoring rules (no source-grep-only assertions, no logic re-implementation).
- [x] 1.2 Document the single opt-in live-test variable (e.g. `TF_RUN_LIVE_TESTS=1`) and the credential-absent skip behaviour.
- [x] 1.3 Add a "new module must ship static + contract tiers" entry to contributor guidance / PR checklist.

## 2. Shared test tooling

- [x] 2.1 Add a reusable Go helper (or `terraform test` convention) for deterministic cloud-auth detection that skips rather than passes when credentials are absent.
- [x] 2.2 Standardise the live-test gate on the single documented env var across helpers.
- [x] 2.3 Decide and document whether `tflint` and a security scanner (`checkov`/`trivy`) are in the static tier now or a follow-up.

## 3. eirctl fast-tier task

- [x] 3.1 Add a `terraform:test` (fast-tier) task to `build/eirctl/tasks.yaml` running `fmt -check`, `init -backend=false`, `validate`, and contract tests for discovered modules.
- [x] 3.2 Add/confirm a context in `build/eirctl/contexts.yaml` that provides `terraform` and `go` (pinned to module `go.mod`).
- [x] 3.3 Add a `test:fast` pipeline entry in `eirctl.yaml`.
- [x] 3.4 Run the task locally and confirm it passes for at least the `azurerm-aks` module.

## 4. CI gate

- [x] 4.1 Confirm `go` availability on the Azure DevOps agent; add a setup/install step if missing.
- [x] 4.2 Add a `Test` job to the Build stage in `build/azdo/azuredevops-runner.yml` that runs the eirctl fast-tier task on PRs.
- [x] 4.3 Introduce the gate in non-blocking (warn) mode first; scope to changed modules via path filtering if needed.
- [x] 4.4 Fix any modules that fail the new static/contract checks.
- [x] 4.5 Flip the gate to required once affected modules are green.

## 5. Reference implementation: azurerm-aks

- [x] 5.1 Replace tautological source-grep tests with `terraform test` (or plan-based) contract tests for variable defaults/types and output wiring.
- [x] 5.2 Convert the workload-identity precondition test to a plan/`terraform test` assertion using `expect_failures`, removing the Go re-implementation `isValidWorkloadIdentityConfiguration`.
- [x] 5.3 Keep `TestModuleInitAndValidate` (static tier) and the example apply gated behind the standard live-test variable.
- [x] 5.4 Update `azurerm/modules/azurerm-aks/test/README.md` to match the current tests (remove stale `TestOidcIssuer*` entries).
- [x] 5.5 Run the migrated suite fast tier and confirm green offline.

## 6. Validation and rollout

- [x] 6.1 Verify the fast tier runs with no cloud credentials and produces a deterministic pass/fail.
- [x] 6.2 Verify a deliberately broken module fails the CI gate.
- [x] 6.3 Verify live tests skip by default and only run with the opt-in variable set.
- [x] 6.4 Update repo conventions/README to point new modules at the standard and reference implementation.
