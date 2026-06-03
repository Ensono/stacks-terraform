package test

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// liveTestEnvVar is the single, repository-wide opt-in switch for live tests.
// Live tests perform a real `terraform apply`/`destroy` against a cloud
// provider and are skipped unless this variable is set to "1".
const liveTestEnvVar = "TF_RUN_LIVE_TESTS"

// TestExampleApplyWhenLiveTestsEnabled is the live tier: it performs a real
// apply of the module example and always registers a deferred destroy so any
// resources are cleaned up even if the apply fails. It is skipped by default.
func TestExampleApplyWhenLiveTestsEnabled(t *testing.T) {
	t.Parallel()

	requireLiveTestOptIn(t)
	requireAzureAuthContext(t)

	exampleDir := filepath.Join(moduleDir(t), "examples", "entire-infra")
	runTerraform(t, exampleDir, "init", "-backend=false")

	defer func() {
		_, _ = runTerraformE(t, exampleDir, "destroy", "-auto-approve", "-input=false")
	}()

	runTerraform(t, exampleDir, "apply", "-auto-approve", "-input=false")
}

// requireLiveTestOptIn skips the test unless the documented opt-in variable is
// set, keeping the fast tiers free of any live execution.
func requireLiveTestOptIn(t *testing.T) {
	t.Helper()

	if os.Getenv(liveTestEnvVar) != "1" {
		t.Skipf("set %s=1 to run costly live Terraform apply coverage", liveTestEnvVar)
	}
}

// requireAzureAuthContext skips (rather than passes) when no Azure
// authentication context is available, so a credential-absent run never
// produces a false pass.
func requireAzureAuthContext(t *testing.T) {
	t.Helper()

	if hasAzureServicePrincipalEnv() || hasAzureCliSession() {
		return
	}

	t.Skip("Azure authentication context is required; set ARM_* variables or log in with az login")
}

func hasAzureServicePrincipalEnv() bool {
	if os.Getenv("ARM_SUBSCRIPTION_ID") == "" || os.Getenv("ARM_TENANT_ID") == "" {
		return false
	}

	if os.Getenv("ARM_CLIENT_ID") != "" && os.Getenv("ARM_CLIENT_SECRET") != "" {
		return true
	}

	if os.Getenv("ARM_USE_OIDC") == "true" && os.Getenv("ARM_CLIENT_ID") != "" {
		return true
	}

	return false
}

func hasAzureCliSession() bool {
	cmd := exec.Command("az", "account", "show")
	cmd.Stdout = nil
	cmd.Stderr = nil

	return cmd.Run() == nil
}
