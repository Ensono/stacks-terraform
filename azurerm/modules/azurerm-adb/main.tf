data "azurerm_client_config" "current" {
}


resource "azurerm_databricks_workspace" "example" {
  name                = var.resource_namer
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.databricks_sku
  
  
  tags = var.resource_tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
