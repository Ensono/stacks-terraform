moved {
  from = tls_private_key.reg_key
  to   = tls_private_key.reg_key[0]
}

moved {
  from = tls_private_key.cert_private_key
  to   = tls_private_key.cert_private_key[0]
}

moved {
  from = tls_cert_request.req
  to   = tls_cert_request.req[0]
}
