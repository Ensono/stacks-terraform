package test

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// TestModuleInitAndValidate is the static tier: it runs `terraform init`
// (without a backend) and `terraform validate` for the module. It requires no
// cloud credentials and creates no billable resources.
func TestModuleInitAndValidate(t *testing.T) {
	t.Parallel()

	moduleDir := moduleDir(t)

	runTerraform(t, moduleDir, "init", "-backend=false")
	runTerraform(t, moduleDir, "validate")
}

func moduleDir(t *testing.T) string {
	t.Helper()

	dir, err := filepath.Abs("..")
	if err != nil {
		t.Fatalf("failed to resolve module directory: %v", err)
	}

	return dir
}

func runTerraform(t *testing.T, dir string, args ...string) string {
	t.Helper()

	output, err := runTerraformE(t, dir, args...)
	if err != nil {
		t.Fatalf("terraform %s failed in %s:\n%s", strings.Join(args, " "), dir, output)
	}

	return output
}

func runTerraformE(t *testing.T, dir string, args ...string) (string, error) {
	t.Helper()

	cmd := exec.Command("terraform", args...)
	cmd.Dir = dir
	cmd.Env = append(os.Environ(), "TF_IN_AUTOMATION=1")
	output, err := cmd.CombinedOutput()

	return string(output), err
}
