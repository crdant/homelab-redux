resource "tls_private_key" "account_key" {
  algorithm   = "RSA"
  rsa_bits = 4096
}

resource "acme_registration" "letsencrypt" {
  account_key_pem = tls_private_key.account_key.private_key_pem
  email_address   = var.email
}

resource "tls_private_key" "certificate_key" {
  algorithm   = "RSA"
  rsa_bits = 4096 
}

resource "tls_cert_request" "request" {
  count = var.request == "" ? 1 : 0

  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.certificate_key.private_key_pem
  dns_names = concat(list(var.host),var.alternates)

  subject {
    common_name = var.host
  }
}

locals {
  certificate_request = var.request != "" ? var.request : tls_cert_request.request[0].cert_request_pem
}

resource "acme_certificate" "certificate" {
  account_key_pem  = acme_registration.letsencrypt.account_key_pem
  certificate_request_pem = local.certificate_request

  dns_challenge {
    provider = "gcloud"
    config = {
        GCE_PROJECT = jsondecode(var.gcp_service_account).project_id
        GCE_SERVICE_ACCOUNT = var.gcp_service_account
    }
  }
}