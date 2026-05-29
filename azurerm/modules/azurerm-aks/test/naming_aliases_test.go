package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestNamingAliasesResolveThroughCanonicalLocals(t *testing.T) {
	t.Parallel()

	moduleDir := filepath.Clean("..")

	variablesContents, err := os.ReadFile(filepath.Join(moduleDir, "variables.tf"))
	require.NoError(t, err)

	localsContents, err := os.ReadFile(filepath.Join(moduleDir, "locals.tf"))
	require.NoError(t, err)

	variablesFile := string(variablesContents)
	localsFile := string(localsContents)

	require.Contains(t, variablesFile, "variable \"internal_ingress_enabled\"")
	require.Contains(t, variablesFile, "variable \"aks_private_cluster_enabled\"")
	require.Contains(t, variablesFile, "Deprecated alias for internal_ingress_enabled")
	require.Contains(t, variablesFile, "Deprecated alias for aks_private_cluster_enabled")

	require.Contains(t, localsFile, "resolved_internal_ingress_enabled")
	require.Contains(t, localsFile, "resolved_aks_private_cluster_enabled")
	require.Contains(t, localsFile, "coalesce(var.internal_ingress_enabled, var.is_cluster_private, false)")
	require.Contains(t, localsFile, "coalesce(var.aks_private_cluster_enabled, var.private_cluster_enabled, false)")
	require.Contains(t, localsFile, "var.internal_ingress_enabled == null || var.is_cluster_private == null || var.internal_ingress_enabled == var.is_cluster_private")
	require.Contains(t, localsFile, "var.aks_private_cluster_enabled == null || var.private_cluster_enabled == null || var.aks_private_cluster_enabled == var.private_cluster_enabled")
}

func TestExamplesPreferPreferredNaming(t *testing.T) {
	t.Parallel()

	appGatewayExampleContents, err := os.ReadFile(filepath.Join("..", "..", "azurerm-app-gateway", "examples", "appgateway-entire", "main.tf"))
	require.NoError(t, err)

	appGatewayVarsContents, err := os.ReadFile(filepath.Join("..", "..", "azurerm-app-gateway", "examples", "appgateway-entire", "variables.tf"))
	require.NoError(t, err)

	aksExampleContents, err := os.ReadFile(filepath.Join("..", "examples", "entire-infra", "main.tf"))
	require.NoError(t, err)

	appGatewayExample := string(appGatewayExampleContents)
	appGatewayVars := string(appGatewayVarsContents)
	aksExample := string(aksExampleContents)

	require.Contains(t, appGatewayExample, "internal_ingress_enabled    = var.internal_ingress_enabled")
	require.Contains(t, appGatewayExample, "aks_private_cluster_enabled = var.aks_private_cluster_enabled")
	require.Contains(t, appGatewayExample, "var.internal_ingress_enabled ? module.aks_bootstrap.aks_ingress_private_ip : module.aks_bootstrap.aks_ingress_public_ip")
	require.NotContains(t, appGatewayVars, "variable \"is_cluster_private\"")
	require.Contains(t, appGatewayVars, "variable \"internal_ingress_enabled\"")
	require.Contains(t, appGatewayVars, "variable \"aks_private_cluster_enabled\"")
	require.Contains(t, aksExample, "internal_ingress_enabled")
	require.Contains(t, aksExample, "aks_private_cluster_enabled")
}

func TestDefaultNodePoolModelsAzureUpgradeSettingsDefaults(t *testing.T) {
	t.Parallel()

	aksContents, err := os.ReadFile(filepath.Join("..", "aks.tf"))
	require.NoError(t, err)

	aksFile := string(aksContents)

	require.Contains(t, aksFile, "upgrade_settings {")
	require.Contains(t, aksFile, "drain_timeout_in_minutes      = 0")
	require.Contains(t, aksFile, "max_surge                     = \"10%\"")
	require.Contains(t, aksFile, "node_soak_duration_in_minutes = 0")
}
