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

    for_each = var.github_enabled ? toset([1]) : toset([])
    content {
      account_name    = var.account_name
      branch_name     = var.branch_name
      git_url         = var.git_url
      repository_name = var.repository_name
      root_folder     = var.root_folder
    }
  }

  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

