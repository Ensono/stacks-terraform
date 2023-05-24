resource "tls_private_key" "reg_key" {
  algorithm = "RSA"
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "req" {
  private_key_pem = tls_private_key.cert_private_key.private_key_pem
  dns_names       = ["*.${var.dns_zone}", var.dns_zone]

  subject {
    common_name = "*.${var.dns_zone}"
  }
}

# If the create_valid_cert is set to false then generate a self-signed certificate
resource "tls_self_signed_cert" "self_cert" {
  count = var.create_valid_cert ? 0 : 1

  private_key_pem = tls_private_key.cert_private_key.private_key_pem
  dns_names       = ["*.${var.dns_zone}", var.dns_zone]

  validity_period_hours = 1461

  subject {
    common_name = "*.${var.dns_zone}"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "pkcs12_from_pem" "self_cert_p12" {
  count = var.create_valid_cert ? 0 : 1

  password        = var.pfx_password
  cert_pem        = tls_self_signed_cert.self_cert.0.cert_pem
  private_key_pem = tls_private_key.cert_private_key.private_key_pem
}

# NEED TO CREATE A REQUEST INLINE to ensure we can access the p12 cert since it's empty if used cert_req_pem
# This is only created if the create_valid_cert is set to true

resource "acme_registration" "reg" {
  count           = var.create_valid_cert ? 1 : 0
  account_key_pem = tls_private_key.reg_key.private_key_pem
  email_address   = var.acme_email
}

resource "acme_certificate" "default" {

  count = var.create_valid_cert ? 1 : 0

  account_key_pem = acme_registration.reg.0.account_key_pem
  common_name     = "*.${var.dns_zone}"
  # subject_alternative_names = ["*.${var.dns_zone}", var.dns_zone]
  # certificate_request_pem = tls_cert_request.req.cert_request_pem
  certificate_p12_password = var.pfx_password

  disable_complete_propagation = var.disable_complete_propagation

  dns_challenge {
    provider = "azure"
    config = {
      AZURE_RESOURCE_GROUP = local.dns_resource_group
    }
  }
}


