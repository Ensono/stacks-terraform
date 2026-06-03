# --- Firewall Rule Groups ---

# This is to alert on ICMP Traffic
resource "aws_networkfirewall_rule_group" "icmp_alert_fw_rule_group" {
  count = var.firewall_enabled ? 1 : 0

  name        = "${var.vpc_name}-icmp-alert-fw-rule-group"
  description = "ICMP Alert Rule Group"
  capacity    = var.icmp_alert_capacity
  type        = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "ALERT"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          protocol         = "ICMP"
          direction        = "ANY"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid"

          settings = [
            "1",
          ]
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-network-firewall-rule-group-alert-icmp"
    },
  )
}

# This Rule is used to catch SNI names from the alert log-group
# https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/use-network-firewall-to-capture-the-dns-domain-names-from-the-server-name-indication-sni-for-outbound-traffic.html

resource "aws_networkfirewall_rule_group" "tls_alert_fw_rule_group" {
  count = var.firewall_enabled && var.create_tls_alert_rule ? 1 : 0

  name        = "${var.vpc_name}-tls-alert-fw-rule-group"
  description = "TLS Alert Rule Group"
  capacity    = var.tls_alert_capacity
  type        = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "ALERT"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          protocol         = "TLS"
          direction        = "FORWARD"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid"

          settings = [
            "4",
          ]
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-network-firewall-rule-group-alert-tls"
    },
  )
}

# This rule allows traffic to flow only for the allowed domain list.
resource "aws_networkfirewall_rule_group" "domain_allow_fw_rule_group" {
  count = var.firewall_enabled && length(var.firewall_allowed_domain_targets) > 0 ? 1 : 0

  name        = "${var.vpc_name}-domain-allow-fw-rule-group"
  description = "Domain Allow FW Rule Group"
  capacity    = var.domain_allow_capacity
  type        = "STATEFUL"

  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["HTTP_HOST", "TLS_SNI"]
        targets              = var.firewall_allowed_domain_targets
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-network-firewall-rule-group-allow-domainlist"
    },
  )
}
