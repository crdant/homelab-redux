resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "letsencrypt" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.letsencrypt.account_key_pem}"
  common_name               = "${var.host}"
  subject_alternative_names = var.alternates

  dns_challenge {
    provider = "gcloud"
    config = {
        GCE_PROJECT = jsondecode(var.gcp_service_account).project_id
        GCE_SERVICE_ACCOUNT = var.gcp_service_account
    }
  }
}

resource "kubernetes_secret" "tls_secret" {
  metadata {
    name = "${var.host}-tls"
    namespace = var.namespace
  }

  data = {
    "tls.key" = acme_certificate.certificate.private_key_pem
    "tls.crt"  = acme_certificate.certificate.certificate_pem
    "ca.crt"  = acme_certificate.certificate.issuer_pem
  }

  type = "kubernetes.io/tls"
}