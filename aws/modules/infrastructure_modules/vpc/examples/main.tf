module "amido_stacks_infra" {
  source = "../"

  # Deployment Region
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "example-vpc"

  firewall_deletion_protection = false

  tags = {}
}

provider "aws" {
  region = "eu-west-1"
}
