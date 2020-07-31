resource "kubernetes_namespace" "example" {
  metadata {
    name = "cert-manager"
  }
}

module "cert_manager_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.jetstack
  chart = "cert-manager"
  namespace = kubernetes_namespace.cert_manager.metadata.name`

  values_files = list("${local.directories.values}/${var.namespace}/cert-manager.yml")
}
