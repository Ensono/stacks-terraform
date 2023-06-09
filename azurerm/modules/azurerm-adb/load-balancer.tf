resource "azurerm_lb" "lb" {
  count = var.enable_private_network && var.create_lb ? 1 : 0

  name                = var.resource_namer
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name

  sku = "Standard"

  frontend_ip_configuration {
    name                 = "Databricks-PIP"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_outbound_rule" "lb_rule" {
  count = var.enable_private_network && var.create_lb ? 1 : 0

  name                = "Databricks-LB-Outbound-Rules"
  resource_group_name = var.resource_group_name

  loadbalancer_id          = azurerm_lb.lb.id
  protocol                 = "All"
  enable_tcp_reset         = true
  allocated_outbound_ports = 1024
  idle_timeout_in_minutes  = 4

  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_be_pool.id

  frontend_ip_configuration {
    name = azurerm_lb.lb.frontend_ip_configuration.0.name
  }
}

resource "azurerm_lb_backend_address_pool" "lb_be_pool" {
  count           = var.enable_private_network && var.create_lb ? 1 : 0
  loadbalancer_id = azurerm_lb.lb.id
  name            = "Databricks-BE"
}