locals {
  vault_host = "vault.${local.subdomain}"
}

module "vault_certificate" {
  source = "../modules/certificate"

  host = "${local.vault_host}"
  email = var.email
  
  gcp_service_account = data.terraform_remote_state.infrastructure.outputs.dns_challenge_account_private_key

  namespace = var.namespace
}

resource "kubernetes_secret" "vault_tls" {
  metadata {
    name = "${local.vault_host}-tls"
    namespace = var.namespace
  }

  data = {
    "tls.key" = module.vault_certificate.private_key
    "tls.crt"  = module.vault_certificate.certificate
    "ca.crt"  = module.vault_certificate.issuer 
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "unseal_account_credentials" {
  metadata {
    name = "${data.terraform_remote_state.infrastructure.outputs.environment}-gcp-credentials"
    namespace = var.namespace
  }
  data = {
    "credentials.json" = data.terraform_remote_state.infrastructure.outputs.unseal_account_private_key
  }
}

module "vault_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.hashicorp
  chart = "vault"
  namespace = var.namespace

  values = {
    project = local.gcp_project
    "unseal_key.ring" = data.terraform_remote_state.infrastructure.outputs.unseal_keyring
    "unseal_key.key"  = data.terraform_remote_state.infrastructure.outputs.unseal_key
    gcp_credentials_secret = kubernetes_secret.unseal_account_credentials.metadata[0].name
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
    command =<<COMMAND
sleep 60
vault operator init
COMMAND
  
    environment = {
      VAULT_ADDR = "https://${local.vault_host}"
      VAULT_CACERT = local_file.vault_certificate_chain.filename
    }
  }

  depends_on = [ module.vault_chart, local_file.vault_certificate_chain ]
}