output "adb_databricks_id" {
  value = azurerm_databricks_workspace.example.id
}

output "databricks_hosturl" {
  description = "Azure Databricks HostUrl"
  value       = "https://${azurerm_databricks_workspace.example.workspace_url}/"
}


############################################
# PRIVATE ENDPOINT
############################################

output "databricks_workspace_private_endpoint_connection_workspace_id" {
  count = var.enable_private_network ? 1 : 0
  value = data.azurerm_databricks_workspace_private_endpoint_connection.example.workspace_id
}

output "databricks_workspace_private_endpoint_connection_private_endpoint_id" {
  count = var.enable_private_network ? 1 : 0
  value = data.azurerm_databricks_workspace_private_endpoint_connection.example.private_endpoint_id
}

output "databricks_workspace_private_endpoint_connection_name" {
  count = var.enable_private_network ? 1 : 0
  value = data.azurerm_databricks_workspace_private_endpoint_connection.example.connections.0.name
}

output "databricks_workspace_private_endpoint_connection_workspace_private_endpoint_id" {
  count = var.enable_private_network ? 1 : 0
  value = data.azurerm_databricks_workspace_private_endpoint_connection.example.connections.0.workspace_private_endpoint_id
}

output "databricks_workspace_private_endpoint_connection_status" {
  count = var.enable_private_network ? 1 : 0
  value = data.azurerm_databricks_workspace_private_endpoint_connection.example.connections.0.status
}

output "databricks_workspace_private_endpoint_connection_description" {
  count = var.enable_private_network ? 1 : 0
  value = data.azurerm_databricks_workspace_private_endpoint_connection.example.connections.0.description
}

output "databricks_workspace_private_endpoint_connection_action_required" {
  count = var.enable_private_network ? 1 : 0
  value = data.azurerm_databricks_workspace_private_endpoint_connection.example.connections.0.action_required
}