provider "kubernetes" {
  alias = "supervisor_cluster"
  config_path = "${local.directories.secrets}/supervisor.kubeconfig"
  config_context = var.namespace
}

provider "kubernetes" {
  alias = "tools_cluster"
  config_path = "${local.directories.secrets}/${var.namespace}.kubeconfig"
  config_context = "kubernetes-admin@${var.namespace}"
}

provider "helm" {
  alias = "tools_cluster"
  kubernetes { 
    config_path = "${local.directories.secrets}/${var.namespace}.kubeconfig"
  }
}
