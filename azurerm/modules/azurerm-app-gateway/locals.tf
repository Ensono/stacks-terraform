locals {

  # Determine the resource group name to use for looking up the 
  # dns zone
  dns_resource_group = coalesce(var.dns_resource_group, var.resource_group_name)

  acme_account_key_rotation_token   = var.acme_account_key_rotation_token == null ? null : nullif(trimspace(var.acme_account_key_rotation_token), "")
  acme_account_key_rotation_enabled = local.acme_account_key_rotation_token != null
}
