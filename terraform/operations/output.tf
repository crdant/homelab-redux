output "namespace" {
  value = var.namespace
}

output "minio_host" {
  value = local.minio_host
}

output "minio_key_secret" {
  value = kubernetes_secret.minio.metadata[0].name
}


