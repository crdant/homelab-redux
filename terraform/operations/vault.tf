module "vault_certificate" {
  source = "../modules/certificate"

  host = "vault.${local.subdomain}"
  email = var.email
  
  gcp_service_account = module.dns_challenge_service_account.private_key

  namespace = var.namespace
}

module "vault_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.hashicorp
  chart = "vault"
  namespace = "operations"

  values = {
    project = var.gcp_project
    "unseal_key.ring" = google_kms_key_ring.vault.name
    "unseal_key.key"  = google_kms_crypto_key.unseal.name
  }
  values_files = list("${local.directories.values}/${var.namespace}/vault.yml")
  overlay_files = list("${local.directories.overlay}/${var.namespace}/vault")

  dependencies = [ module.vault_certificate.certificate ]
}

resource "local_file" "vault_certificate_chain" {
  content = <<CHAIN
${module.vault_certificate.certificate}
${module.vault_certificate.issuer}
CHAIN
  filename = "${local.directories.secrets}/vault.crt"
}

resource "null_resource" "vault_init" {
  provisioner "local-exec" { 
    command = "vault operator init"
  
    environment = {
      VAULT_ADDR = "https://vault.${local.subdomain}"
      VAULT_CACERT = local_file.vault_certificate_chain.filename
    }
  }

  depends_on = [ local_file.vault_certificate_chain ]
}

