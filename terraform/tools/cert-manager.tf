resource "kubernetes_namespace" "cert_manager" {
  provider = kubernetes.tools_cluster
  metadata {
    name = "cert-manager"
  }
}

module "cert_manager_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.jetstack
  chart = "cert-manager"
  namespace = kubernetes_namespace.cert_manager.metadata.0.name

  values_files = list("${local.directories.values}/${var.namespace}/cert-manager.yml")

  providers = {
    helm = helm.tools_cluster
  }
}
