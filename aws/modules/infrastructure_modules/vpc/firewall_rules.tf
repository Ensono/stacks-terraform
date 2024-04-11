# --- Firewall Rule Groups ---

# This is to alert on ICMP Traffic
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

# This Rule is used to catch SNI names from the alert log-group
# https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/use-network-firewall-to-capture-the-dns-domain-names-from-the-server-name-indication-sni-for-outbound-traffic.html

resource "aws_networkfirewall_rule_group" "tls_alert_fw_rule_group" {
  count = var.firewall_enabled && var.create_custom_rule ? 1 : 0

  name        = "${var.vpc_name}-tls-alert-fw-rule-group"
  description = "TLS Alert Rule Group"
  capacity    = 500
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

  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-rule-group-alert-tls"
  })
}

# This rule allows traffic to flow only for the allowed domain list.
resource "aws_networkfirewall_rule_group" "domain_allow_fw_rule_group" {
  count = var.firewall_enabled && length(var.firewall_allowed_domain_targets) > 0 ? 1 : 0

  name        = "${var.vpc_name}-domain-allow-fw-rule-group"
  description = "Domain Allow FW Rule Group"
  capacity    = 1000
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

# Suricata rule to drop any inbound traffic other than traffic on port 443 (HTTPS). 
resource "aws_networkfirewall_rule_group" "block_ingress_non_https_port_rule_group" {
  count    = var.firewall_enabled && var.create_custom_rule ? 1 : 0
  capacity = 500
  name     = "${var.vpc_name}-drop-ingress-non-https-traffic"
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
      alert ip any any -> $HOME_NET ![443] (msg:"Inbound traffic on port other than 443"; sid:1000001; rev:1;)
      drop ip any any -> $HOME_NET ![443] (msg:"Drop all non-HTTPS traffic"; sid:1000002; rev:1;)
      EOF
    }
  }
  tags = merge(var.tags, {
    "Name" = "${var.vpc_name}-network-firewall-rule-group-drop-non-https-traffic"
  })
}
