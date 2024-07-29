module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace  = "${var.name_company}-${var.name_project}"
  stage      = var.stage
  name       = "${lookup(var.location_name_map, var.resource_group_location, "westeurope")}-${var.name_component}"
  attributes = var.attributes
  delimiter  = "-"
  tags       = var.tags
}

module "app" {
  source = "../../"

  create_cosmosdb         = var.create_cosmosdb
  resource_namer          = module.default_label.id
  resource_tags           = module.default_label.tags
  resource_group_location = var.resource_group_location
  create_cache            = var.create_cache
  create_dns_record       = var.create_dns_record
  create_cdn_endpoint     = var.create_cdn_endpoint
  subscription_id         = data.azurerm_client_config.current.subscription_id
}
