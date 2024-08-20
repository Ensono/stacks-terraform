moved {
  from = azurerm_resource_group.default
  to   = azurerm_resource_group.default[0]
}

moved {
  from = module.cosmosdb
  to   = module.cosmosdb[0]
}
