data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group
}

# Generates Random Password for VMSS Admin
resource "random_password" "password" {
  count            = var.vmss_admin_password == "" ? 1 : 0
  length           = 16
  min_upper        = 2
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = var.vmss_name
  location                        = var.vmss_resource_group_location
  resource_group_name             = var.vmss_resource_group_name
  sku                             = var.vmss_sku
  instances                       = var.vmss_instances
  admin_username                  = var.vmss_admin_username
  admin_password                  = var.vmss_admin_password == "" ? random_password.password[0].result : var.vmss_admin_password
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
  extension {
    name                       = "CustomScript"
    publisher                  = "Microsoft.Azure.Extensions"
    type                       = "CustomScript"
    type_handler_version       = "2.0"
    auto_upgrade_minor_version = true

    settings = jsonencode({
      "script" = base64encode(data.local_file.sh.content)
    })
  }

  extension {
    auto_upgrade_minor_version = false
    automatic_upgrade_enabled  = false
    name                       = "Microsoft.Azure.DevOps.Pipelines.Agent"
    provision_after_extensions = [
      "CustomScript",
    ]
    publisher = "Microsoft.VisualStudio.Services"
    settings = jsonencode(
      {
        agentDownloadUrl        = "https://vstsagentpackage.azureedge.net/agent/3.225.0/vsts-agent-linux-x64-3.225.0.tar.gz"
        agentFolder             = "/agent"
        enableScriptDownloadUrl = "https://vstsagenttools.blob.core.windows.net/tools/ElasticPools/Linux/15/enableagent.sh"
        isPipelinesAgent        = true
      }
    )
    type                 = "TeamServicesAgentLinux"
    type_handler_version = "1.23"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

data "local_file" "sh" {
  filename = "${path.module}/ci_cd_tool_install.sh"
}
