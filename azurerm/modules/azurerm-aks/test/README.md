# AKS Module Tests

This directory contains automated tests for the Azure Kubernetes Service (AKS) Terraform module.

## OIDC Issuer Tests

The `oidc_issuer_test.go` file contains tests for the OIDC issuer enabled feature:

### Test Cases

1. **TestOidcIssuerEnabledDefault**: Validates that OIDC issuer is enabled by default when no variable is specified.

2. **TestOidcIssuerEnabledVariable**: Verifies that OIDC issuer can be explicitly enabled by setting `oidc_issuer_enabled = true`.

3. **TestOidcIssuerDisabledVariable**: Verifies that OIDC issuer can be disabled by setting `oidc_issuer_enabled = false`.

4. **TestOidcIssuerVariableType**: Validates that the `oidc_issuer_enabled` variable is correctly defined as a boolean type.

5. **TestOidcIssuerVariableDefault**: Validates that the default value of `oidc_issuer_enabled` is `true`.

## Prerequisites

- Terraform >= 1.0
- Go >= 1.21
- Terratest library

## Running the Tests

### Install Dependencies

```bash
cd test
go mod download
```

### Run All Tests

```bash
cd test
go test -v -timeout 30m
```

### Run Specific Test

```bash
cd test
go test -v -run TestOidcIssuerEnabledDefault -timeout 30m
```

### Run Tests in Parallel

```bash
cd test
go test -v -parallel 4 -timeout 30m
```

## Notes

- Tests are marked as parallel-safe with `t.Parallel()` for faster execution
- Integration tests that deploy actual infrastructure require proper Azure credentials and may incur costs
- The `InitAndApplyE` function is used to gracefully handle failures in test environments where Azure credentials may not be available
- All tests clean up resources with `terraform destroy` via `defer`

## Test Environment Variables

Some tests may require Azure credentials:

```bash
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
export ARM_CLIENT_ID="<your-client-id>"
export ARM_CLIENT_SECRET="<your-client-secret>"
export ARM_TENANT_ID="<your-tenant-id>"
```

## References

- [Terratest Documentation](https://terratest.gruntwork.io/)
- [OIDC Issuer in Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/use-oidc-issuer)
