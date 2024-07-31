resource "azurerm_cdn_profile" "default" {
  count = var.create_cdn_endpoint ? 1 : 0

  name                = var.resource_namer
  location            = "global"
  resource_group_name = azurerm_resource_group.default.0.name
  sku                 = "Standard_Microsoft"

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_cdn_endpoint" "default" {
  count = var.create_cdn_endpoint ? 1 : 0

  name                = var.resource_namer
  profile_name        = azurerm_cdn_profile.default.0.name
  location            = "global"
  resource_group_name = azurerm_resource_group.default.0.name

  origin {
    name      = var.resource_namer
    host_name = var.create_dns_record && var.dns_enable_alias_record ? replace(azurerm_dns_a_record.default.0.fqdn, "/.$/", "") : var.dns_a_records.0
  }

  # If we are using an Alias we want to point to the incoming Host Header for
  # the upstream communication
  origin_host_header = var.create_dns_record && var.dns_enable_alias_record ? "${var.dns_record}.${var.dns_zone_name}" : var.dns_a_records.0

  global_delivery_rule {
    dynamic "modify_response_header_action" {
      for_each = var.response_header_cdn
      iterator = response_header
      content {
        action = response_header.value["action"]                                              # (Required) Action to be executed on a header value. Valid values are Append, Delete and Overwrite.
        name   = response_header.value["name"]                                                # (Required) The header name.
        value  = response_header.value["value"] == "" ? null : response_header.value["value"] # (Optional) The value of the header. Only needed when action is set to Append or overwrite.
      }
    }
  }
  delivery_rule {
    name = "DefaultHTTPRedirect"
    # order = length(var.response_header_cdn) * 10
    order = 1
    request_scheme_condition {
      match_values     = toset(["HTTP"]) # (Required) Valid values are HTTP and HTTPS.
      operator         = "Equal"         # (Optional) Valid values are Equal.
      negate_condition = false           # (Optional) Defaults to false.
    }
    url_redirect_action {
      redirect_type = "Moved"
      protocol      = "Https"
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_dns_cname_record" "default" {
  count = var.create_cdn_endpoint ? 1 : 0

  name                = var.dns_record
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = var.dns_ttl
  record              = azurerm_cdn_endpoint.default.0.fqdn
}

resource "azurerm_cdn_endpoint_custom_domain" "default" {
  name            = var.resource_namer
  cdn_endpoint_id = azurerm_cdn_endpoint.default.0.id
  host_name       = trimsuffix(azurerm_dns_cname_record.default.0.fqdn, ".")

  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
    tls_version      = var.cdn_tls_version
  }
}
