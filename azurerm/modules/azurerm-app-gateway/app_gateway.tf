resource "azurerm_subnet" "frontend" {
  name                 = var.resource_namer
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_front_end_prefix]
  depends_on           = [var.vnet_name]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_backend_end_prefix]
  depends_on           = [var.vnet_name]
}

resource "azurerm_public_ip" "app_gateway" {
  name                = var.resource_namer
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.vnet_name}-beap"
  frontend_port_name             = "${var.vnet_name}-feport"
  frontend_port_name_ssl         = "${var.vnet_name}-feportssl"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name              = "${var.vnet_name}-be-htst"
  listener_name                  = "${var.vnet_name}-httplstn"
  listener_name_ssl              = "${var.vnet_name}-httplstn_ssl"
  request_routing_rule_name      = "${var.vnet_name}-rqrt"
  request_routing_rule_name_ssl  = "${var.vnet_name}-rqrt_ssl"
  redirect_configuration_name    = "${var.vnet_name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = var.resource_namer
  resource_group_name = var.resource_group_name

  location = var.resource_group_location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${var.resource_namer}-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = local.frontend_port_name_ssl
    port = 443
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  http_listener {
    name                           = local.listener_name_ssl
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_ssl
    protocol                       = "Https"
    ssl_certificate_name           = "frontend"
  }

  ssl_certificate {
    name     = "frontend"
    data     = var.create_valid_cert ? acme_certificate.default.0.certificate_p12 : pkcs12_from_pem.self_cert_p12.0.result
    password = var.pfx_password
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [var.aks_ingress_ip]
  }

  probe {
    name                = "k8s-probe"
    host                = "127.0.0.1"
    protocol            = "Http"
    interval            = 15
    unhealthy_threshold = 4
    timeout             = 15
    path                = "/healthz"
    match {
      status_code = ["200"]
    }
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 10
    probe_name            = "k8s-probe"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name_ssl
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name_ssl
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  # ssl_policy = var.ssl_policy
  ssl_policy { # block supports the following:
    policy_type          = lookup(var.ssl_policy, "policy_type")
    policy_name          = lookup(var.ssl_policy, "policy_name")
    min_protocol_version = lookup(var.ssl_policy, "min_protocol_version")
    disabled_protocols   = lookup(var.ssl_policy, "disabled_protocols")
    cipher_suites        = lookup(var.ssl_policy, "cipher_suites")
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
