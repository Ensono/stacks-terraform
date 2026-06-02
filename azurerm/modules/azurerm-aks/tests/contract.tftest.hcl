# Contract tier: offline plan-based assertions using mocked providers.
# Runs without cloud credentials and creates no billable resources.

mock_provider "azurerm" {}
mock_provider "tls" {}

variables {
  name_company                      = "ensono"
  name_project                      = "example"
  name_component                    = "infra"
  name_environment                  = "dev"
  vnet_cidr                         = ["10.0.0.0/16"]
  subnet_prefixes                   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  subnet_names                      = ["k8s1", "k8s2", "k8s3"]
  subnet_front_end_prefix           = "10.0.3.0/24"
  aks_ingress_private_ip            = "10.0.0.10"
  spn_object_id                     = "00000000-0000-0000-0000-000000000000"
  tenant_id                         = "00000000-0000-0000-0000-000000000000"
  dns_zone                          = "example.com"
  internal_dns_zone                 = "example.internal"
  dns_create_parent_zone_ns_records = false
}

run "defaults_wire_oidc_and_workload_identity" {
  command = plan

  assert {
    condition     = azurerm_kubernetes_cluster.default[0].oidc_issuer_enabled == true
    error_message = "oidc_issuer_enabled should default to true and wire through to the cluster"
  }

  assert {
    condition     = azurerm_kubernetes_cluster.default[0].workload_identity_enabled == false
    error_message = "workload_identity_enabled should default to false and wire through to the cluster"
  }

  assert {
    condition     = output.aks_workload_identity_enabled == false
    error_message = "aks_workload_identity_enabled output should be false by default"
  }
}

run "workload_identity_enabled_with_oidc" {
  command = plan

  variables {
    oidc_issuer_enabled       = true
    workload_identity_enabled = true
  }

  assert {
    condition     = azurerm_kubernetes_cluster.default[0].workload_identity_enabled == true
    error_message = "workload_identity_enabled should wire through to the cluster when enabled"
  }

  assert {
    condition     = output.aks_workload_identity_enabled == true
    error_message = "aks_workload_identity_enabled output should reflect the enabled workload identity"
  }
}
