## ADDED Requirements

### Requirement: Tiered test taxonomy for Terraform modules

Every Terraform module under `*/modules/**` SHALL classify its tests into three tiers: **static**, **contract**, and **live**. Each test file or test case MUST belong to exactly one tier and MUST be runnable in isolation by tier. The static and contract tiers MUST NOT require cloud credentials or create billable resources.

#### Scenario: Static tier requires no credentials

- **WHEN** the static tier is executed without any cloud credentials configured
- **THEN** it runs `terraform fmt -check`, `terraform init -backend=false`, and `terraform validate` for the module
- **AND** it completes without contacting a cloud provider and without creating resources

#### Scenario: Contract tier runs offline against fixtures

- **WHEN** the contract tier is executed without cloud credentials
- **THEN** it exercises module behaviour through `terraform plan` (or `terraform test`) against local fixtures with `-backend=false`
- **AND** it asserts on plan results, preconditions, and variable/output wiring without creating billable resources

#### Scenario: Live tier is isolated from fast tiers

- **WHEN** a contributor runs the static or contract tier
- **THEN** no test that performs `terraform apply` against real infrastructure is executed

### Requirement: Fast test tier is a required CI gate

The repository CI pipeline SHALL run the static and contract tiers (the "fast tier") for affected modules on every pull request, and the pipeline MUST fail when any fast-tier test fails. The fast tier MUST be deterministic and MUST NOT depend on cloud credentials.

#### Scenario: PR with broken module fails the gate

- **WHEN** a pull request introduces a module change that fails `terraform validate` or a contract test
- **THEN** the CI fast-tier stage reports a failure
- **AND** the pull request is blocked from merging on that failed gate

#### Scenario: Fast tier runs without secrets

- **WHEN** the CI fast-tier stage runs on a fork or an agent without cloud secrets
- **THEN** the static and contract tiers still execute and produce a pass/fail result

#### Scenario: Single command runs the fast tier

- **WHEN** a contributor runs the documented `eirctl` test task locally
- **THEN** the fast tier executes the same checks that CI runs for the affected modules

### Requirement: Live tests are explicit opt-in

Tests that perform real `terraform apply`/`destroy` against a cloud provider SHALL be skipped by default and MUST execute only when a single documented opt-in environment variable is set. Live tests MUST guarantee cleanup of any resources they create.

#### Scenario: Live test skipped by default

- **WHEN** the test suite runs without the documented opt-in variable set
- **THEN** every live test is skipped with a message explaining how to enable it

#### Scenario: Live test enabled explicitly

- **WHEN** the documented opt-in variable is set and valid cloud authentication is present
- **THEN** the live test runs a real apply and registers a deferred destroy so resources are cleaned up even on failure

#### Scenario: Authentication missing is a skip, not a pass

- **WHEN** a live test is requested but cloud authentication is absent
- **THEN** the test is skipped with a clear message rather than passing without asserting

### Requirement: Tests assert behaviour, not source text

Module tests SHALL verify behaviour through `terraform validate`, `terraform plan`, or `terraform test` outputs. Tests MUST NOT assert correctness solely by string-matching the contents of `.tf` source files, and MUST NOT re-implement module logic in test code and then assert against that copy.

#### Scenario: Precondition verified through plan

- **WHEN** a test verifies a module precondition or validation rule
- **THEN** it runs `terraform plan` (or `terraform test`) against a fixture and asserts on the emitted error or planned values
- **AND** it does not rely on grepping the module source for the precondition expression

#### Scenario: No tautological logic duplication

- **WHEN** a reviewer inspects a contract test for a conditional rule
- **THEN** the test exercises the Terraform configuration rather than a Go/HCL re-implementation of the same condition

### Requirement: New modules ship minimum test coverage

Any newly added Terraform module SHALL include at least the static and contract tiers before it can be merged, and the module's test directory MUST document how to run each tier. Documentation of tests MUST stay consistent with the tests that exist.

#### Scenario: New module without contract tests is rejected

- **WHEN** a new module is proposed without static or contract tier tests
- **THEN** the CI fast-tier gate or review checklist flags the module as non-compliant

#### Scenario: Test documentation matches reality

- **WHEN** a module's test README lists test cases
- **THEN** each documented test case exists in the suite and no removed test remains documented
