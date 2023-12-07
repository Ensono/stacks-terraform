# --- Route Tables ---
# --- Public route table ---
resource "aws_route_table" "public" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = module.vpc.vpc_id

  tags = merge(var.tags, {
    "Name"       = "${var.vpc_name}-public-${data.aws_availability_zones.available.names[count.index]}"
    "isPrivate"  = "false"
    "isPublic"   = "true"
    "isLambda"   = "false"
    "isFirewall" = "false"
    "isDB"       = "false"
  })
}

# --- Firewall route table ---
resource "aws_route_table" "network_firewall" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = module.vpc.vpc_id

  tags = merge(var.tags, {
    "Name"       = "${var.vpc_name}-firewall-${data.aws_availability_zones.available.names[count.index]}"
    "isPrivate"  = "false"
    "isPublic"   = "true"
    "isLambda"   = "false"
    "isFirewall" = "true"
    "isDB"       = "false"
  })
}

# --- Ingress route table ---
resource "aws_route_table" "ingress_route_table" {
  vpc_id = module.vpc.vpc_id

  tags = merge(var.tags, {
    "Name"       = "${var.vpc_name}-ingress-route-table"
    "isPublic"   = "true"
    "isPrivate"  = "false"
    "isPam"      = "false"
    "isFirewall" = "false"
    "isDB"       = "false"
  })
}

# --- Route Table Association ---
# Private, Database, and Lambda subnets share a route table per AZ
# Private and Database subnets are set-up by the AWS VPC module, Lambda is
# created by this module so we add them to the Route Tables from the module
resource "aws_route_table_association" "lambda" {
  count          = length(aws_subnet.lambda)
  subnet_id      = aws_subnet.lambda[count.index].id
  route_table_id = module.vpc.private_route_table_ids[count.index]
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "network_firewall" {
  count          = length(aws_subnet.network_firewall)
  subnet_id      = aws_subnet.network_firewall[count.index].id
  route_table_id = aws_route_table.network_firewall[count.index].id
}

resource "aws_route_table_association" "ingress_route_table_gw_association" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.ingress_route_table.id

  depends_on = [aws_internet_gateway.igw]
}

# --- Routes ---
# Default route towards nat gateway for private subnets
resource "aws_route" "nat" {
  count = length(module.vpc.private_route_table_ids)

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.vpc_nat_gateway_per_az ? aws_nat_gateway.public[count.index].id : aws_nat_gateway.public[0].id
  route_table_id         = module.vpc.private_route_table_ids[count.index]
}

# Default route towards Internet Gateway for Firewall if enabled
resource "aws_route" "firewall_to_internet_gw" {
  count = length(aws_subnet.network_firewall)

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.network_firewall[count.index].id
}

# Default route towards Internet Gateway for Public if Firewall is disabled
resource "aws_route" "public_to_internet_gw" {
  count = var.firewall_enabled == false ? length(aws_subnet.public) : 0

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.public[count.index].id
}

# Default route towards firewall for public subnets
resource "aws_route" "public_to_firewall_endpoints" {
  count = var.firewall_enabled ? length(aws_subnet.public) : 0

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public[count.index].id
  vpc_endpoint_id        = element([for ep in tolist(aws_networkfirewall_firewall.firewall.0.firewall_status[0].sync_states) : ep.attachment[0].endpoint_id if ep.attachment[0].subnet_id == aws_subnet.network_firewall[count.index].id], 0)

  depends_on = [aws_route_table.ingress_route_table]
}

# Ingress route towards firewall for public subnets on the internet gateway routing table
resource "aws_route" "ingress_routes" {
  count = var.firewall_enabled ? length(aws_subnet.public) : 0

  route_table_id         = aws_route_table.ingress_route_table.id
  destination_cidr_block = aws_subnet.public[count.index].cidr_block
  vpc_endpoint_id        = element([for ep in tolist(aws_networkfirewall_firewall.firewall.0.firewall_status[0].sync_states) : ep.attachment[0].endpoint_id if ep.attachment[0].subnet_id == aws_subnet.network_firewall[count.index].id], 0)

  depends_on = [aws_route_table.ingress_route_table]
}
