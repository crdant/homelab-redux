output "environment" {
  value = local.environment 
}

output "subdomain" {
  value = local.subdomain
}

output "gcp_domain" {
  value = local.gcp_domain
}

output "gcp_project" {
  value = var.gcp_project
}

output "dns_challenge_account_id" {
  value = module.dns_challenge_service_account.id
}

output "dns_challenge_account_private_key" {
  value = module.dns_challenge_service_account.private_key
  sensitive = true
}

output "unseal_account_id" {
  value = module.vault_service_account.id
}

output "unseal_account_private_key" {
  value = module.vault_service_account.private_key
  sensitive = true
}

output "unseal_keyring" {
  value = google_kms_key_ring.vault.name 
}

output "unseal_key" {
  value = google_kms_crypto_key.unseal.name 
}

output "rye_id" { 
  value = data.vsphere_host.rye.id
}