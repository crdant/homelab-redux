provider "helm" {
  alias = "tools_cluster"
  kubernetes { 
    config_path = "${local.directories.secrets}/${var.namespace}.kubeconfig"
  }
}
