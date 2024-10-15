# acr
resource "azurerm_container_registry" "registry" {
  count               = var.create_acr ? 1 : 0
  name                = replace(var.acr_registry_name, "-", "")
  resource_group_name = azurerm_resource_group.default.name
  location            = var.resource_group_location
  admin_enabled       = var.registry_admin_enabled
  sku                 = var.registry_sku

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# aks cluster
# this should not be an option otherwise cluster will fail if missing
resource "tls_private_key" "ssh_key" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
}

resource "azurerm_kubernetes_cluster" "default" {
  count                   = var.create_aks ? 1 : 0
  name                    = var.resource_namer
  location                = var.resource_group_location
  resource_group_name     = azurerm_resource_group.default.name
  dns_prefix              = var.dns_prefix
  kubernetes_version      = var.cluster_version
  sku_tier                = var.cluster_sku_tier
  private_cluster_enabled = var.private_cluster_enabled

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = chomp(tls_private_key.ssh_key[0].public_key_openssh)
    }
  }

  default_node_pool {
    # TODO: variablise below:
    type                        = var.nodepool_type # "VirtualMachineScaleSets" # default
    enable_auto_scaling         = var.enable_auto_scaling
    max_count                   = var.max_nodes
    min_count                   = var.min_nodes
    name                        = "default"
    os_disk_size_gb             = var.os_disk_size
    vm_size                     = var.vm_size
    node_count                  = var.min_nodes
    vnet_subnet_id              = azurerm_subnet.default.0.id
    temporary_name_for_rotation = "default_tmp"
    zones                       = var.enable_availability_zones ? var.availabilty_zones : null # Only available on provision
  }

  http_application_routing_enabled  = false
  role_based_access_control_enabled = true

  oms_agent {
    # enabled                    = true
    log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  }

  network_profile {
    network_plugin    = var.advanced_networking_enabled ? "azure" : "kubenet"
    network_policy    = var.advanced_networking_enabled ? "azure" : null
    load_balancer_sku = "standard"
    # service_cidr    = "172.0.0.0/16"
    # load_balancer_profile {
    #   outbound_ip_address_ids = azurerm_public_ip.default[*].id
    # }
  }
  # TODO: this should be changed to UserAssigned once available
  # SPN should be removed once out of preview
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      windows_profile,
      tags
    ]
  }
  depends_on = [
    azurerm_virtual_network.default
  ]
}

# Create additional node pools if they have been specified
resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.aks_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default[0].id
  vm_size               = each.value.vm_size
  enable_auto_scaling   = each.value.auto_scaling
  min_count             = each.value.min_nodes
  max_count             = each.value.max_nodes
  node_count            = each.value.min_nodes
  vnet_subnet_id        = azurerm_subnet.default.0.id
  zones                 = each.value.enable_availability_zones ? each.value.availabilty_zones : null # Only available on provision
}

# perform lookup on existing ACR for stages where we don't want to create an ACR
data "azurerm_container_registry" "acr_registry" {
  count               = var.create_acr ? 0 : 1
  name                = var.acr_registry_name
  resource_group_name = var.acr_resource_group
  depends_on = [
    var.acr_resource_group
  ]
}

resource "azurerm_role_assignment" "acr" {
  scope                = var.create_acr ? azurerm_container_registry.registry.0.id : data.azurerm_container_registry.acr_registry.0.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.default.0.identity.0.principal_id
  depends_on = [
    azurerm_kubernetes_cluster.default
  ]
}

data "azurerm_resource_group" "aks_rg_id" {
  name = azurerm_kubernetes_cluster.default.0.node_resource_group
  depends_on = [
    azurerm_kubernetes_cluster.default
  ]
}

data "azurerm_user_assigned_identity" "aks_rg_id" {
  name                = "${var.resource_namer}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.default.0.node_resource_group
  depends_on = [
    azurerm_kubernetes_cluster.default
  ]
}

resource "azurerm_role_assignment" "acr2" {
  scope                            = var.create_acr ? azurerm_container_registry.registry.0.id : data.azurerm_container_registry.acr_registry.0.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.aks_rg_id.principal_id
  skip_service_principal_aad_check = true
  depends_on = [
    azurerm_kubernetes_cluster.default
  ]
  lifecycle {
    ignore_changes = [name]
  }
}

# MSI must have permissions to create subnets
# Ensure if using private networks
resource "azurerm_role_assignment" "network" {
  scope                = local.vnet_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.default.0.identity.0.principal_id
  depends_on = [
    azurerm_kubernetes_cluster.default
  ]
}

resource "azurerm_public_ip" "external_ingress" {
  count               = 1
  name                = format("${var.resource_namer}-%d", count.index)
  location            = var.resource_group_location
  resource_group_name = azurerm_kubernetes_cluster.default.0.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  # timeouts {
  #   delete = 5
  # }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}
