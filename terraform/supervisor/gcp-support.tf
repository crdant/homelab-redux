module "vault_service_account" {
    source = "../modules/gcp_service_account"

    gcp_project = var.gcp_project

    account_id = "${local.dashed_environment}-kms-access"    
    display_name = "Vault Automation"
    description = "Access to KMS for Vault auto unseal in ${local.environment}"
    roles = [ "roles/cloudkms.cryptoKeyEncrypterDecrypter" ]

    namespace = var.secrets_namespace
}


module "dns_challenge_service_account" {
    source = "../modules/gcp_service_account"

    gcp_project = var.gcp_project
    
    account_id = "${local.dashed_environment}-dns-challenge"    
    display_name = "DNS Challenge"
    description  = "Access to DNS to create certificates for services in ${local.environment}"
    roles = [ "roles/dns.admin" ]

    namespace = var.secrets_namespace
}

resource "google_kms_key_ring" "vault" {
  name     = "${local.dashed_subdomain}-vault"
  location = "global"
}

resource "google_kms_crypto_key" "unseal" {
  name            = "unseal-key"
  key_ring        = google_kms_key_ring.vault.id
  rotation_period = "100000s"
}