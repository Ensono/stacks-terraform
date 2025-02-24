################################################################################
# Public Subnet Network ACLs
################################################################################

resource "aws_network_acl" "public" {
  count = var.create_public_dedicated_network_acl ? 1 : 0

  vpc_id     = module.vpc.vpc_id
  subnet_ids = aws_subnet.public[*].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-acl"
    },
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  count = var.create_public_dedicated_network_acl ? length(var.public_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.public[0].id

  egress          = false
  rule_number     = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_inbound_acl_rules[count.index]["rule_action"]
  protocol        = var.public_inbound_acl_rules[count.index]["protocol"]
  from_port       = var.public_inbound_acl_rules[count.index]["from_port"]
  to_port         = var.public_inbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.public_inbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.public_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_inbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.public_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  count = var.create_public_dedicated_network_acl ? length(var.public_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.public[0].id

  egress          = true
  rule_number     = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_outbound_acl_rules[count.index]["rule_action"]
  protocol        = var.public_outbound_acl_rules[count.index]["protocol"]
  from_port       = var.public_outbound_acl_rules[count.index]["from_port"]
  to_port         = var.public_outbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.public_outbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.public_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_outbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.public_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################################################################
# Private Subnet Network ACLs
################################################################################

resource "aws_network_acl" "private" {
  count = var.create_private_dedicated_network_acl ? 1 : 0

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-acl"
    },
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  count = var.create_private_dedicated_network_acl ? length(var.private_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress          = false
  rule_number     = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
  protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
  from_port       = var.private_inbound_acl_rules[count.index]["from_port"]
  to_port         = var.private_inbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.private_inbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  count = var.create_private_dedicated_network_acl ? length(var.private_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress          = true
  rule_number     = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_outbound_acl_rules[count.index]["rule_action"]
  protocol        = var.private_outbound_acl_rules[count.index]["protocol"]
  from_port       = var.private_outbound_acl_rules[count.index]["from_port"]
  to_port         = var.private_outbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.private_outbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.private_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_outbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.private_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################################################################
# Database Subnet Network ACLs
################################################################################

resource "aws_network_acl" "database" {
  count = var.create_database_dedicated_network_acl ? 1 : 0

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.database_subnets

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-database-acl"
    },
  )
}

resource "aws_network_acl_rule" "database_inbound" {
  count = var.create_database_dedicated_network_acl ? length(var.database_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.database[0].id

  egress          = false
  rule_number     = var.database_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
  protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
  from_port       = var.private_inbound_acl_rules[count.index]["from_port"]
  to_port         = var.private_inbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.private_inbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "database_outbound" {
  count = var.create_database_dedicated_network_acl ? length(var.database_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.database[0].id

  egress          = true
  rule_number     = var.database_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.database_outbound_acl_rules[count.index]["rule_action"]
  protocol        = var.database_outbound_acl_rules[count.index]["protocol"]
  from_port       = var.database_outbound_acl_rules[count.index]["from_port"]
  to_port         = var.database_outbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.database_outbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.database_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.database_outbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.database_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################################################################
# Lambda Subnet Network ACLs
################################################################################

resource "aws_network_acl" "lambda" {
  count = var.create_lambda_dedicated_network_acl ? 1 : 0

  vpc_id     = module.vpc.vpc_id
  subnet_ids = aws_subnet.lambda[*].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-lambda-acl"
    },
  )
}

resource "aws_network_acl_rule" "lambda_inbound" {
  count = var.create_lambda_dedicated_network_acl ? length(var.lambda_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.lambda[0].id

  egress          = false
  rule_number     = var.lambda_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.lambda_inbound_acl_rules[count.index]["rule_action"]
  protocol        = var.lambda_inbound_acl_rules[count.index]["protocol"]
  from_port       = var.lambda_inbound_acl_rules[count.index]["from_port"]
  to_port         = var.lambda_inbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.lambda_inbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.lambda_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.lambda_inbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.lambda_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "lambda_outbound" {
  count = var.create_lambda_dedicated_network_acl ? length(var.lambda_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.lambda[0].id

  egress          = true
  rule_number     = var.lambda_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.lambda_outbound_acl_rules[count.index]["rule_action"]
  protocol        = var.lambda_outbound_acl_rules[count.index]["protocol"]
  from_port       = var.lambda_outbound_acl_rules[count.index]["from_port"]
  to_port         = var.lambda_outbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.lambda_outbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.lambda_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.lambda_outbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.lambda_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################################################################
# Network Firewall Subnet Network ACLs
################################################################################

resource "aws_network_acl" "network_firewall" {
  count = var.create_network_firewall_dedicated_network_acl ? 1 : 0

  vpc_id     = module.vpc.vpc_id
  subnet_ids = aws_subnet.network_firewall[*].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-network-firewall-acl"
    },
  )
}

resource "aws_network_acl_rule" "network_firewall_inbound" {
  count = var.create_network_firewall_dedicated_network_acl ? length(var.network_firewall_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.network_firewall[0].id

  egress          = false
  rule_number     = var.network_firewall_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.network_firewall_inbound_acl_rules[count.index]["rule_action"]
  protocol        = var.network_firewall_inbound_acl_rules[count.index]["protocol"]
  from_port       = var.network_firewall_inbound_acl_rules[count.index]["from_port"]
  to_port         = var.network_firewall_inbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.network_firewall_inbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.network_firewall_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.network_firewall_inbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.network_firewall_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "network_firewall_outbound" {
  count = var.create_network_firewall_dedicated_network_acl ? length(var.network_firewall_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.network_firewall[0].id

  egress          = true
  rule_number     = var.network_firewall_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.network_firewall_outbound_acl_rules[count.index]["rule_action"]
  protocol        = var.network_firewall_outbound_acl_rules[count.index]["protocol"]
  from_port       = var.network_firewall_outbound_acl_rules[count.index]["from_port"]
  to_port         = var.network_firewall_outbound_acl_rules[count.index]["to_port"]
  cidr_block      = var.network_firewall_outbound_acl_rules[count.index]["cidr_block"]
  icmp_code       = lookup(var.network_firewall_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.network_firewall_outbound_acl_rules[count.index], "icmp_type", null)
  ipv6_cidr_block = lookup(var.network_firewall_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}
