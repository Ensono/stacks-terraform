resource "azurerm_cdn_profile" "default" {
  count               = var.create_cdn_endpoint ? 1 : 0
  name                = var.resource_namer
  location            = "global"
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "Standard_Microsoft"
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_cdn_endpoint" "default" {
  count               = var.create_cdn_endpoint ? 1 : 0
  name                = var.resource_namer
  profile_name        = azurerm_cdn_profile.default.0.name
  location            = "global"
  resource_group_name = azurerm_resource_group.default.name

  origin {
    name      = var.resource_namer
    host_name = var.dns_a_records.0
  }
  origin_host_header = var.dns_a_records.0
  global_delivery_rule {
    dynamic "modify_response_header_action" {
      for_each = var.response_header_cdn
      iterator = response_header
      content {
        action = response_header.value["action"]                                              # (Required) Action to be executed on a header value. Valid values are Append, Delete and Overwrite.
        name   = response_header.value["name"]                                                # (Required) The header name.
        value  = response_header.value["value"] == "" ? null : response_header.value["value"] #(Optional) The value of the header. Only needed when action is set to Append or overwrite.
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
  count               = var.create_cdn_endpoint ? 1 : 0
  name                = var.dns_record
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = var.dns_ttl
  record              = azurerm_cdn_endpoint.default.0.host_name
}

# Workaround for setting custom domain on the CDN
resource "null_resource" "custom_domain" {
  count = var.create_cdn_endpoint ? 1 : 0
  triggers = {
    trigger_hostname = azurerm_dns_cname_record.default.0.fqdn
  }
  provisioner "local-exec" {
    command = <<EOF
    az cdn custom-domain create --endpoint-name ${azurerm_cdn_endpoint.default.0.name} --hostname ${trimsuffix(azurerm_dns_cname_record.default.0.fqdn, ".")} \
      --name ${var.resource_namer} \
      --profile-name ${azurerm_cdn_profile.default.0.name} \
      --resource-group ${azurerm_resource_group.default.name} \
      --subscription ${var.subscription_id}
    EOF
  }
  depends_on = [azurerm_dns_cname_record.default]
  lifecycle {
    ignore_changes = [
      id,
    ]
  }
}

# Workaround for a current bug
# CLI version 2.31 - still exists
# https://github.com/Azure/azure-cli/issues/12152
# can be set to az cli once fixed
# end goal to remove and make this part of terraform onec Go SDK from MS makes this possible
# az cdn custom-domain enable-https --endpoint-name ${azurerm_cdn_endpoint.default.name} \
#   --name ${local.app_hostname} \
#   --profile-name ${azurerm_cdn_profile.default.name} \
#   --resource-group ${azurerm_resource_group.default.name} \
#   --subscription ${var.subscription_id}
resource "null_resource" "custom_domain_ssl" {
  count = var.create_cdn_endpoint ? 1 : 0
  triggers = {
    # trigger_hostname = lookup(sort(azurerm_cdn_endpoint.default.origin)[0], "host_name")
    trigger_hostname = azurerm_dns_cname_record.default.0.fqdn
  }
  provisioner "local-exec" {
    command = <<EOF
    az rest --method post --uri /subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.default.name}/providers/Microsoft.Cdn/profiles/${azurerm_cdn_profile.default.0.name}/endpoints/${azurerm_cdn_endpoint.default.0.name}/customDomains/${var.resource_namer}/enableCustomHttps?api-version=2019-06-15-preview \
    --body "{\"certificateSource\":\"Cdn\",\"protocolType\":\"ServerNameIndication\",\"certificateSourceParameters\":{\"@odata.type\":\"#Microsoft.Azure.Cdn.Models.CdnCertificateSourceParameters\",\"certificateType\":\"Dedicated\"}}"
    EOF
  }
  depends_on = [null_resource.custom_domain]
  lifecycle {
    ignore_changes = [
      id,
    ]
  }
}
