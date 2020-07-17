provider "acme" {
  # USe Staging endpoint
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "reg_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_key.private_key_pem
  email_address   = var.acme_email
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "req" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.cert_private_key.private_key_pem
  dns_names       = ["*.${var.dns_zone}", var.dns_zone]

  subject {
    common_name = "*.${var.dns_zone}"
  }
}

# NEED TO CREATE A REQUEST INLINE to ensure we can access the p12 cert since it's empty if used cert_req_pem
resource "acme_certificate" "default" {
  account_key_pem         = acme_registration.reg.account_key_pem
  common_name             = "*.${var.dns_zone}"
  # subject_alternative_names = ["*.${var.dns_zone}", var.dns_zone]
  # certificate_request_pem = tls_cert_request.req.cert_request_pem
  certificate_p12_password = var.pfx_password
  dns_challenge {
    provider = "azure"
    config = {
      AZURE_RESOURCE_GROUP = var.resource_group_name
    }
  }
}


