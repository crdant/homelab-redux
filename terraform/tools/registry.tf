resource "kubernetes_namespace" "registry" {
  provider = kubernetes.tools_cluster
  metadata {
    name = "registry"
  }

  depends_on = [
    local_file.kubeconfig
  ]
}

module "harbor_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.jetstack
  chart = "harbor"
  namespace = kubernetes_namespace.registry.metadata.0.name

  secrets_files = list("${local.directories.secrets}/harbor-s3-credentials.yml")
  values_files = list("${local.directories.values}/${var.namespace}/harbor.yml")

  providers = {
    helm = helm.tools_cluster
  }
}
