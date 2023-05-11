data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = var.vmss_name
  location                        = var.vmss_resource_group_location
  resource_group_name             = var.vmss_resource_group_name
  sku                             = var.vmss_sku
  instances                       = var.vmss_instances
  admin_username                  = var.vmss_admin_username
  admin_password                  = var.vmss_admin_password
  disable_password_authentication = var.vmss_disable_password_auth
  overprovision                   = var.overprovision

  source_image_reference {
    publisher = var.vmss_image_publisher
    offer     = var.vmss_image_offer
    sku       = var.vmss_image_sku
    version   = var.vmss_image_version
  }

  network_interface {
    name    = var.network_interface_name
    primary = true

    ip_configuration {
      name      = var.ip_configuration_name
      primary   = true
      subnet_id = data.azurerm_subnet.subnet.id
    }
  }

  os_disk {
    storage_account_type = var.vmss_storage_account_type
    caching              = var.vmss_disk_caching
  }
}