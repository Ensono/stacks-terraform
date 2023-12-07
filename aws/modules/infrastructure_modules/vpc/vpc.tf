# NOTE: This module assumes no more than 3 Availability Zones.
# If you use a region with more you might need to update the CIDRs used.
# This is a basic network layout and is designed to be changed and updated.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.2"

  name             = var.vpc_name
  cidr             = var.vpc_cidr
  azs              = data.aws_availability_zones.available.names
  private_subnets  = [for k, v in data.aws_availability_zones.available.names : cidrsubnet(var.vpc_cidr, 4, k)]
  database_subnets = [for k, v in data.aws_availability_zones.available.names : cidrsubnet(var.vpc_cidr, 4, k + 3)]

  # NAT
  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  create_igw             = false
  instance_tenancy       = var.vpc_instance_tenancy

  private_subnet_suffix  = "private"
  database_subnet_suffix = "database"

  # VPC DNS
  enable_dns_hostnames    = true
  map_public_ip_on_launch = false

  private_subnet_tags = merge(var.tags, {
    "kubernetes.io/cluster/${var.vpc_name}" = "owned"
    "kubernetes.io/role/internal-elb"       = "1"
    "isPrivate"                             = "true"
    "isPublic"                              = "false"
    "isLambda"                              = "false"
    "isFirewall"                            = "false"
    "isDB"                                  = "false"
    }, # { "karpenter.sh/discovery" : var.vpc_name }
  )

  private_route_table_tags = merge(var.tags, {
    "isPrivate"  = "true"
    "isPublic"   = "false"
    "isLambda"   = "false"
    "isFirewall" = "false"
    "isDB"       = "false"
  })

  database_subnet_tags = merge(var.tags, {
    "isPrivate"  = "true"
    "isPublic"   = "false"
    "isLambda"   = "false"
    "isFirewall" = "false"
    "isDB"       = "true"
  })

  database_route_table_tags = merge(var.tags, {
    "isPrivate"  = "true"
    "isPublic"   = "false"
    "isLambda"   = "false"
    "isFirewall" = "false"
    "isDB"       = "true"
  })

  tags = {}
}

# --- Public Subnets ---
resource "aws_subnet" "public" {
  count                           = length(data.aws_availability_zones.available.zone_ids)
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = cidrsubnet(var.vpc_cidr, 4, 6 + count.index)
  availability_zone_id            = data.aws_availability_zones.available.zone_ids[count.index]
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(var.tags, {
    "Name"                                  = "${var.vpc_name}-public-${data.aws_availability_zones.available.names[count.index]}"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/${var.vpc_name}" = "owned"
    "isPrivate"                             = "false"
    "isPublic"                              = "true"
    "isLambda"                              = "false"
    "isFirewall"                            = "false"
    "isDB"                                  = "false"
  })
}

# --- Lambda Subnets ---
resource "aws_subnet" "lambda" {
  count                           = length(data.aws_availability_zones.available.names)
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = cidrsubnet(var.vpc_cidr, 4, 9 + count.index)
  availability_zone_id            = data.aws_availability_zones.available.zone_ids[count.index]
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(var.tags, {
    "Name"       = "${var.vpc_name}-lambda-${data.aws_availability_zones.available.names[count.index]}"
    "isPrivate"  = "true"
    "isPublic"   = "false"
    "isLambda"   = "true"
    "isFirewall" = "false"
    "isDB"       = "false"
  })
}

# --- AWS Network Firewall Subnets ---
resource "aws_subnet" "network_firewall" {
  count                           = var.firewall_enabled ? length(data.aws_availability_zones.available.names) : 0
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = cidrsubnet(var.vpc_cidr, 12, 4080 + count.index)
  availability_zone_id            = data.aws_availability_zones.available.zone_ids[count.index]
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(var.tags, {
    "Name"                   = "${var.vpc_name}-network-firewall-${data.aws_availability_zones.available.names[count.index]}"
    "kubernetes.io/role/elb" = "0"
    "isPrivate"              = "false"
    "isPublic"               = "true"
    "isLambda"               = "false"
    "isFirewall"             = "true"
    "isDB"                   = "false"
  })
}

# --- EIP ---
resource "aws_eip" "nat" {
  count = length(data.aws_availability_zones.available.zone_ids)

  domain = "vpc"

  tags = merge(var.tags, {
    "Name" = var.vpc_name,
    "Tier" = "OUT_NAT"
  })
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-internet-gateway"
  })
}

# --- NAT Gateway ---
resource "aws_nat_gateway" "public" {
  count = var.vpc_nat_gateway_per_az ? length(data.aws_availability_zones.available.names) : 1

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-public-nat-${data.aws_availability_zones.available.names[count.index]}"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
