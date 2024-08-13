moved {
  from = azurerm_resource_group.default
  to   = azurerm_resource_group.default[0]
}

moved {
  from = module.app.module.cosmosdb
  to   = module.app.module.cosmosdb[0]
}
