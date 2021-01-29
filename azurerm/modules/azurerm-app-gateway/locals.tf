locals {

    # Determine the resource group name to use for looking up the 
    # dns zone
    dns_resource_group = coalesce(var.dns_resource_group, var.resource_group_name)
}