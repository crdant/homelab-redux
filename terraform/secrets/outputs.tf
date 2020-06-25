output "vault_addr" {
   value = "https://${local.vault_host}" 
}

output "vault_certificate" {
   value = module.vault_certificate.certificate 
}