module "amido_stacks_infra" {
  source = "../../"

  # Deployment Region
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "AWSDEVLONVPCCORE"

  vpc_subnet_names_public = [
    "AWSDEVLONSUBCOREPUB1",
    "AWSDEVLONSUBCOREPUB2",
    "AWSDEVLONSUBCOREPUB3",
  ]

  vpc_subnet_names_private = [
    "AWSDEVLONSUBCOREPRV1",
    "AWSDEVLONSUBCOREPRV2",
    "AWSDEVLONSUBCOREPRV3",
  ]

  vpc_subnet_names_database = [
    "AWSDEVLONSUBCOREDAB1",
    "AWSDEVLONSUBCOREDAB2",
    "AWSDEVLONSUBCOREDAB3",
  ]

  vpc_subnet_names_firewall = [
    "AWSDEVLONSUBCOREFWL1",
    "AWSDEVLONSUBCOREFWL2",
    "AWSDEVLONSUBCOREFWL3",
  ]

  vpc_subnet_names_lambda = [
    "AWSDEVLONSUBCORELMD1",
    "AWSDEVLONSUBCORELMD2",
    "AWSDEVLONSUBCORELMD3",
  ]

  firewall_enabled = false

  vpc_internet_gateway_name = "AWSDEVLONIGWCORE"
  vpc_ingress_route_table_name = "AWSDEVLONIRTCORE"
  vpc_nat_gateway_names = [
    "AWSDEVLONNGWCORE1",
    "AWSDEVLONNGWCORE2",
    "AWSDEVLONNGWCORE3",
  ]

  firewall_deletion_protection = false

  flow_log_enabled = true

  tags = {}
}

provider "aws" {
  region = "eu-west-1"
}
