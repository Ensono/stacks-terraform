# Contract tier: precondition assertion using a mocked plan.
# Verifies the module precondition behaviour rather than grepping the source.

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

run "workload_identity_requires_oidc_issuer" {
  command = plan

  variables {
    oidc_issuer_enabled       = false
    workload_identity_enabled = true
  }

  expect_failures = [
    azurerm_kubernetes_cluster.default,
  ]
}
