resource "vault_ldap_auth_backend" "ldap" {
    path        = "ldap"
    url         = "ldaps://${local.ldap_host}" 
    binddn      = var.vault_ldap_bind_dn
    bindpass    = var.vault_ldap_bind_password
    userdn      = "ou=people,o=homelab,dc=crdant,dc=net"
    userattr    = "uid"
    groupdn     = "ou=groups,o=homelab,dc=crdant,dc=net"
    certificate = module.ldap_certificate.certificate
}