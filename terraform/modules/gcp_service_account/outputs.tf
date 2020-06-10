output "secret" {
  value = kubernetes_secret.credentials.metadata[0].name
}

output "private_key" {
  value = base64decode(google_service_account_key.key.private_key)
  sensitive = true
}

output "id" {
  value = base64decode(google_service_account_key.key.private_key)
}