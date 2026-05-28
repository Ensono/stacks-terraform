locals {

  # Determine the resource group name to use for looking up the
  # dns zone
  dns_resource_group = var.create_dns_zone ? var.resource_namer : coalesce(var.dns_resource_group, var.resource_namer)

  resolved_internal_ingress_enabled    = coalesce(var.internal_ingress_enabled, var.is_cluster_private, false)
  resolved_aks_private_cluster_enabled = coalesce(var.aks_private_cluster_enabled, var.private_cluster_enabled, false)
}

check "internal_ingress_enabled_alias_consistency" {
  assert {
    condition     = var.internal_ingress_enabled == null || var.is_cluster_private == null || var.internal_ingress_enabled == var.is_cluster_private
    error_message = "Conflicting values were provided for internal_ingress_enabled and deprecated is_cluster_private. Set only internal_ingress_enabled, or set both inputs to the same value."
  }
}

check "aks_private_cluster_enabled_alias_consistency" {
  assert {
    condition     = var.aks_private_cluster_enabled == null || var.private_cluster_enabled == null || var.aks_private_cluster_enabled == var.private_cluster_enabled
    error_message = "Conflicting values were provided for aks_private_cluster_enabled and deprecated private_cluster_enabled. Set only aks_private_cluster_enabled, or set both inputs to the same value."
  }
}
