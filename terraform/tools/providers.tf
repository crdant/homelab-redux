provider "kubernetes" {
  alias = "supervisor_cluster"
  config_path = "${local.directories.secrets}/supervisor.kubeconfig"
  config_context = var.namespace
}

provider "kubernetes" {
  alias = "tools_cluster"
  config_path = "${local.directories.secrets}/${var.namespace}.kubeconfig"
}

provider "helm" {
  alias = "tools_cluster"
  kubernetes { 
    config_path = "${local.directories.secrets}/${var.namespace}.kubeconfig"
  }
}

provider "minio" {
  minio_server = data.terraform_remote_state.operations.outputs.minio_host
  minio_access_key = data.kubernetes_secret.minio_access_key.data.access-key
  minio_secret_key = data.kubernetes_secret.minio_access_key.data.secret-key
  minio_ssl = true
}
