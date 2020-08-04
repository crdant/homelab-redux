resource "vault_ldap_auth_backend" "ldap" {
    path        = "ldap"
    url         = "ldaps://${local.ldap_host}" 
    binddn      = var.vault_ldap_bind_dn
    bindpass    = var.vault_ldap_bind_password
    userdn      = "ou=people,o=homelab,${local.base_dn}"
    userattr    = "uid"
    groupdn     = "ou=groups,o=homelab,${local.base_dn}"
    certificate = module.ldap_certificate.certificate
}

resource "vault_auth_backend" "approle" {
    type = "approle"
}

resource "vault_policy" "security" {
  name = "administrators"
  policy = file("${local.directories.policy}/security.hcl")
}

resource "vault_ldap_auth_backend_group" "security" {
    groupname = "security"
    policies  = ["security"]
    backend   = vault_ldap_auth_backend.ldap.path
}

resource "vault_policy" "operators" {
  name = "operators"
  policy = file("${local.directories.policy}/operators.hcl")
}

resource "vault_ldap_auth_backend_group" "operators" {
    groupname = "operators"
    policies  = ["operators"]
    backend   = vault_ldap_auth_backend.ldap.path
}

resource "vault_policy" "developers" {
  name = "developers"
  policy = file("${local.directories.policy}/developers.hcl")
}

resource "vault_ldap_auth_backend_group" "developers" {
    groupname = "developers"
    policies  = ["developers"]
    backend   = vault_ldap_auth_backend.ldap.path
}

resource "vault_mount" "transit" {
	path = "transit"
	type = "transit"
	default_lease_ttl_seconds = 3600
	max_lease_ttl_seconds     = 86400
}

