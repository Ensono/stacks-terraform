moved {
  from = azurerm_role_assignment.acr
  to   = azurerm_role_assignment.acr[0]
}

moved {
  from = azurerm_role_assignment.acr2
  to   = azurerm_role_assignment.acr2[0]
}

moved {
  from = azurerm_role_assignment.network
  to   = azurerm_role_assignment.network[0]
}
