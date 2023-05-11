output "subnet_ids" {
  value = values(azurerm_subnet.example)[*].id
}

output "hub_net_id" {
  value = data.azurerm_virtual_network.hub_network.id
}

output "subnet_names" {
  value = values(azurerm_subnet.example)[*].name
}

output "subnets" {
  value = {
    for sub in azurerm_subnet.example :
    sub.name => ({
      vnet_names       = sub.virtual_network_name
      id               = sub.id
      address_prefixes = sub.address_prefixes

    })


  }
}

output "vnets" {
  value = {
    for vnet in azurerm_virtual_network.example :
    vnet.name => ({
      vnet_id            = vnet.id
      vnet_address_space = vnet.address_space

    })


  }
}
