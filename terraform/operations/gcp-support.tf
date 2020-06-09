module "vault_service_account" {
    source = "../modules/gcp_service_account"

    gcp_project = var.gcp_project

    account_id = "${var.namespace}-vault"    
    display_name = "Vault Automation"
    description = "Access to KMS for Vault auto unseal"
    roles = [ "roles/cloudkms.cryptoKeyEncrypterDecrypter" ]

    namespace = var.namespace
}


module "dns_challenge_service_account" {
    source = "../modules/gcp_service_account"

    gcp_project = var.gcp_project
    
    account_id = "${var.namespace}-dns-challenge"    
    display_name = "DNS Challenge"
    description  = "Access to DNS to create certificates for services installed at ${var.namespace}"
    roles = [ "roles/dns.admin" ]

    namespace = var.namespace
}

resource "google_kms_key_ring" "vault" {
  name     = "lab-${var.namespace}-vault"
  location = "global"
}

resource "google_kms_crypto_key" "unseal" {
  name            = "unseal-key"
  key_ring        = google_kms_key_ring.vault.id
  rotation_period = "100000s"
}