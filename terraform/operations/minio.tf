module "minio_certificate" {
  source = "../modules/certificate"

  host = "s3.${local.subdomain}"
  email = var.email
  
  gcp_service_account = data.terraform_remote_state.infrastructure.outputs.dns_challenge_account_private_key

  namespace = var.namespace
}

resource "kubernetes_secret" "minio_tls" {
  metadata {
    name = "${local.minio_host}-tls"
    namespace = var.namespace
  }

  data = {
    "tls.key" = module.minio_certificate.private_key
    "tls.crt"  = module.minio_certificate.certificate
    "ca.crt"  = module.minio_certificate.issuer 
  }

  type = "kubernetes.io/tls"
}

resource "random_pet" "access_key" { 
  length = 2  
}

resource "random_pet" "secret_key" { 
  length = 5  
}

resource "kubernetes_secret" "minio" {
  metadata {
    name = "minio"
    namespace = var.namespace
  }

  data = {
    "access-key" = random_pet.access_key.id
    "secret-key" = random_pet.secret_key.id
    "vault.crt" = data.terraform_remote_state.secrets.outputs.vault_certificate
  }
}

resource "vault_transit_secret_backend_key" "minio" {
  backend = "${vault_mount.transit.path}"
  name    = "minio"
}

resource "vault_policy" "minio" {
  name = "minio"
  policy = file("${local.directories.policy}/minio.hcl")
}

resource "vault_approle_auth_backend_role" "minio" {
  backend        = vault_auth_backend.approle.path
  role_name      = "minio-minio"
  token_policies = [ vault_policy.minio.name ]
}

resource "vault_approle_auth_backend_role_secret_id" "minio" {
  backend   = "${vault_auth_backend.approle.path}"
  role_name = "${vault_approle_auth_backend_role.minio.role_name}"
}

locals {
  minio_vault_config = {
    endpoint = data.terraform_remote_state.secrets.outputs.vault_addr 
    approle = {
      id = vault_approle_auth_backend_role.minio.role_id 
      secret = vault_approle_auth_backend_role_secret_id.minio.secret_id 
    }
  }
}

resource "random_id" "kms_master_key" {
  byte_length = 32
}

module "minio_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.bitnami
  chart = "minio"
  namespace = var.namespace

  values = {
    "master_key" = random_id.kms_master_key.hex
    "vault" = yamlencode(local.minio_vault_config)
    "ldap.host" = local.ldap_host
    "ldap.baseDN" = local.base_dn
  }

  values_files = list("${local.directories.values}/${var.namespace}/minio.yml")
  overlay_files = list("${local.directories.overlay}/${var.namespace}/minio")

  dependencies = [ module.minio_certificate.certificate ]
}
