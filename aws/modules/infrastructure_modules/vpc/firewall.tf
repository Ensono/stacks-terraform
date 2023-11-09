# --- AWS Network Firewall ---
resource "aws_networkfirewall_firewall" "firewall" {
  name                = "${var.vpc_name}-network-firewall"
  description         = "Network Firewall for the VPC"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.policy.arn
  vpc_id              = module.vpc.vpc_id

  dynamic "subnet_mapping" {
    for_each = aws_subnet.network_firewall[*].id

    content {
      subnet_id = subnet_mapping.value
    }
  }

  delete_protection = var.firewall_deletion_protection

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall"
  })
}

# --- Firewall Logging ---
resource "aws_cloudwatch_log_group" "firewall_alert_log_group" {
  name              = "/aws/network-firewall/${var.vpc_name}-network-firewall/alert"
  retention_in_days = var.firewall_alert_log_retention

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-alert-logs"
  })
}

resource "aws_cloudwatch_log_group" "firewall_flow_log_group" {
  name              = "/aws/network-firewall/${var.vpc_name}-network-firewall/flow"
  retention_in_days = var.firewall_flow_log_retention

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-flow-logs"
  })
}

resource "aws_networkfirewall_logging_configuration" "firewall_logging_config" {
  firewall_arn = aws_networkfirewall_firewall.firewall.arn

  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.firewall_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }

    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.firewall_flow_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
}

# --- Firewall Policy ---
resource "aws_networkfirewall_firewall_policy" "policy" {
  name = "${var.vpc_name}-network-firewall-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.icmp_alert_fw_rule_group.arn
    }

    dynamic "stateful_rule_group_reference" {
      for_each = length(var.firewall_allowed_domain_targets) > 0 ? [0] : []

      content {
        resource_arn = aws_networkfirewall_rule_group.domain_allow_fw_rule_group.0.arn
      }
    }
  }

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-policy"
  })
}
