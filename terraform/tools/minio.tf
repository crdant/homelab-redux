data "kubernetes_secret" "minio_access_key" {
  provider = kubernetes.supervisor_cluster

  metadata {
    name = data.terraform_remote_state.operations.outputs.minio_key_secret
    namespace = data.terraform_remote_state.operations.outputs.namespace
  }
}
