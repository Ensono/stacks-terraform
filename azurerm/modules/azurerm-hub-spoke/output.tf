
output "hub_net_name" {
  value = local.hub_network_name[0]
}

output "hub_net_id" {
  value = azurerm_virtual_network.example["${local.hub_network_name[0]}"].id
}

output "subnet_ids" {
  value = values(azurerm_subnet.example)[*].id
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

output "hub_firewall_id" {

  value = azurerm_subnet.az_fw_subnet[0].id
}

output "hub_pub_ip" {

  value = azurerm_public_ip.example[0].id
}
