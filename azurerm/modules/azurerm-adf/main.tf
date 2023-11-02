resource "azurerm_data_factory" "example" {
  count                           = var.create_adf ? 1 : 0
  name                            = var.resource_namer
  location                        = var.resource_group_location
  resource_group_name             = var.resource_group_name
  public_network_enabled          = var.public_network_enabled
  managed_virtual_network_enabled = var.managed_virtual_network_enabled

  # optional block Adf identity 
  dynamic "identity" {

    for_each = var.adf_idenity ? toset([1]) : toset([0])
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }


  #git configuration 
  dynamic "github_configuration" {

    for_each = var.git_integration == "github" ? toset([1]) : toset([])
    content {
      account_name    = var.github_account_name
      branch_name     = var.branch_name
      git_url         = var.github_url
      repository_name = var.repository_name
      root_folder     = var.root_folder
    }
  }

  #vsts configuration 
  dynamic "vsts_configuration" {

    for_each = var.git_integration == "vsts" ? toset([1]) : toset([])
    content {
      account_name    = var.vsts_account_name
      branch_name     = var.branch_name
      project_name    = var.vsts_project_name
      repository_name = var.repository_name
      root_folder     = var.root_folder
      tenant_id       = var.tenant_id
    }
  }


  #global parameter configuration 
  dynamic "global_parameter" {

    for_each = { for i in var.global_parameter : i.name => i }
    content {
      name  = global_parameter.key
      type  = global_parameter.value.type
      value = global_parameter.value.value
    }
  }

  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_data_factory_integration_runtime_azure" "example" {
  count                   = var.managed_virtual_network_enabled ? 1 : 0
  name                    = var.adf_managed-vnet-runtime_name
  data_factory_id         = azurerm_data_factory.example[0].id
  location                = var.resource_group_location
  virtual_network_enabled = var.runtime_virtual_network_enabled
}

resource "azapi_resource_action" "test" {
  count       = var.ir_enable_interactive_authoring && var.managed_virtual_network_enabled ? 1 : 0
  type        = "Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01"
  resource_id = azurerm_data_factory_integration_runtime_azure.example[0].id
  action      = "enableInteractiveQuery"
  body = jsonencode({
    autoTerminationMinutes = 10
  })
  depends_on = [azurerm_data_factory_integration_runtime_azure.example]
}
