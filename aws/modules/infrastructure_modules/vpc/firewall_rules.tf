# --- Firewall Rule Groups ---
resource "aws_networkfirewall_rule_group" "icmp_alert_fw_rule_group" {
  count = var.firewall_enabled ? 1 : 0

  name        = "${var.vpc_name}-icmp-alert-fw-rule-group"
  description = "ICMP Alert Rule Group"
  capacity    = 100
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

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-rule-group-alert-icmp"
  })
}

resource "aws_networkfirewall_rule_group" "domain_allow_fw_rule_group" {
  count = var.firewall_enabled && length(var.firewall_allowed_domain_targets) > 0 ? 1 : 0

  name        = "${var.vpc_name}-domain-allow-fw-rule-group"
  description = "Domain Allow FW Rule Group"
  capacity    = 100
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

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-rule-group-allow-domainlist"
  })
}

# This rule blocks the use of the SSH Outbound Over non-standard ports.
resource "aws_networkfirewall_rule_group" "blocks_ssh_over_non_standard_ports" {
  count = var.firewall_enabled ? 1 : 0
  capacity = 100
  name     = "drop-ssh-outbound-over-non-standard-ports"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.vpc_cidr]
        }
      }
      ip_sets {
        key = "EXTERNAL_NET"
        ip_set {
          definition = ["0.0.0.0/0"]
        }
      }
    }
    rules_source {
      rules_string = <<EOF
      reject ssh $HOME_NET any -> $EXTERNAL_NET !22 (msg:"Block use of SSH protocol on non-standard port"; flow: to_server; sid:2171010;)
      EOF
    }
  }
  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-rule-group-allow-domainlist"
  })
}
