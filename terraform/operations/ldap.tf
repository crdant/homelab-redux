module "ldap_certificate" {
  source = "../modules/certificate"

  host = local.ldap_host
  email = var.email
  
  gcp_service_account = data.terraform_remote_state.supervisor.outputs.dns_challenge_account_private_key

  namespace = var.namespace
}

resource "random_pet" "ldap_admin_password" {
  length = 4
}

resource "random_pet" "ldap_config_password" {
  length = 4
}

resource "kubernetes_secret" "ldap_passwords" {
  metadata {
    name = "openldap-password"
    namespace = var.namespace
  }

  data = {
    LDAP_ADMIN_PASSWORD = random_pet.ldap_admin_password.id
    LDAP_CONFIG_PASSWORD  = random_pet.ldap_config_password.id
  }

}

module "ldap_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.stable
  chart = "openldap"
  namespace = "operations"

  values_files = list("${local.directories.values}/${var.namespace}/openldap.yml")

  dependencies = [ module.ldap_certificate.certificate ]
}