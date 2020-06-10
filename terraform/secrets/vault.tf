module "vault_certificate" {
  source = "../modules/certificate"

  host = "vault.${local.subdomain}"
  email = var.email
  
  gcp_service_account = data.terraform_remote_state.supervisor.outputs.dns_challenge_account_private_key

  namespace = var.namespace
}

module "vault_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.hashicorp
  chart = "vault"
  namespace = var.namespace

  values = {
    project = var.gcp_project
    "unseal_key.ring" = data.terraform_remote_state.supervisor.outputs.unseal_keyring
    "unseal_key.key"  = data.terraform_remote_state.supervisor.outputs.unseal_key
    gcp_credentials_secret = data.terraform_remote_state.supervisor.outputs.unseal_credentials_secret
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
      VAULT_ADDR = "https://vault.${local.subdomain}"
      VAULT_CACERT = local_file.vault_certificate_chain.filename
    }
  }

  depends_on = [ module.vault_chart, local_file.vault_certificate_chain ]
}