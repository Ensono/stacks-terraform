locals {

  # Determine the resource group name to use for looking up the 
  # dns zone
  dns_resource_group = var.create_dns_zone ? var.resource_namer : coalesce(var.dns_resource_group, var.resource_namer)
}