data "azurerm_client_config" "current" {}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace  = "${var.name_company}-${var.name_project}"
  stage      = var.stage
  name       = var.name_component
  attributes = var.attributes
  delimiter  = "-"
  tags       = var.tags
}

# if you do not set the
# `service_cidr`
# `dns_service_ip`
# `docker_bridge_cidr`
# AKS will default to ==> 10.0.0.0/16
variable "vnet_cidr" {
  default = ["10.1.0.0/16"]
}

module "example_aks" {
  source                            = "../../"
  resource_namer                    = module.default_label.id
  resource_group_location           = "uksouth"
  spn_object_id                     = data.azurerm_client_config.current.object_id
  tenant_id                         = data.azurerm_client_config.current.tenant_id
  # client_id                         = var.create_aksspn ? module.aks-spn.spn_applicationid : var.cluster_spn_clientid
  # client_secret                     = var.create_aksspn ? random_string.spn_password.0.result : var.cluster_spn_clientsecret
  cluster_version                   = "1.29.0"
  name_environment                  = "dev"
  name_project                      = var.name_project
  name_company                      = var.name_company
  name_component                    = var.name_component
  create_dns_zone                   = true
  dns_zone                          = "example.stacks.ensono.com"
  internal_dns_zone                 = "example.stacks.ensono.internal"
  dns_create_parent_zone_ns_records = true
  dns_parent_resource_group         = "stacks-ancillary-resources"
  dns_parent_zone                   = "stacks.ensono.com"
  create_acr                        = true
  acr_registry_name                 = replace(module.default_label.id, "-", "")
  create_aksvnet                    = true
  vnet_name                         = module.default_label.id
  vnet_cidr                         = var.vnet_cidr
  subnet_front_end_prefix           = cidrsubnet(var.vnet_cidr.0, 4, 3)
  subnet_prefixes                   = ["${cidrsubnet(var.vnet_cidr.0, 4, 0)}", "${cidrsubnet(var.vnet_cidr.0, 4, 1)}", "${cidrsubnet(var.vnet_cidr.0, 4, 2)}"]
  subnet_names                      = ["k8s1", "k8s2", "k8s3"]
  enable_auto_scaling               = true
  log_application_type              = "Node.JS"
  aks_ingress_private_ip            = cidrhost(cidrsubnet(var.vnet_cidr.0, 4, 0), -3)
}
