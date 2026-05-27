locals {

  # Determine the resource group name to use for looking up the 
  # dns zone
  dns_resource_group = coalesce(var.dns_resource_group, var.resource_group_name)

  effective_certificate_source = var.certificate_source != null ? var.certificate_source : (var.create_valid_cert ? "acme" : "self_signed")
  create_acme_certificate      = local.effective_certificate_source == "acme"
  create_self_signed_cert      = local.effective_certificate_source == "self_signed"
  use_key_vault_certificate    = local.effective_certificate_source == "key_vault"

  inline_certificate_data = local.create_acme_certificate ? acme_certificate.default[0].certificate_p12 : (
    local.create_self_signed_cert ? pkcs12_from_pem.self_cert_p12[0].result : null
  )

  inline_certificate_pem = local.create_acme_certificate ? acme_certificate.default[0].certificate_pem : (
    local.create_self_signed_cert ? tls_self_signed_cert.self_cert[0].cert_pem : null
  )

  inline_issuer_pem = local.create_acme_certificate ? acme_certificate.default[0].issuer_pem : null

  app_gateway_identity_enabled     = var.identity_type != null
  app_gateway_identity_ids         = distinct(var.user_assigned_identity_ids)
  app_gateway_identity_is_valid    = !local.app_gateway_identity_enabled || length(local.app_gateway_identity_ids) > 0
  key_vault_configuration_is_valid = !local.use_key_vault_certificate || var.key_vault_secret_id != null
  acme_configuration_is_valid      = !local.create_acme_certificate || var.acme_email != null
  key_vault_identity_is_valid      = !local.use_key_vault_certificate || var.identity_type == "UserAssigned"
}
