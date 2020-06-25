module "uaa_db_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.bitnami
  chart = "postgresql"
  namespace = "operations"

  values_files = list("${local.directories.values}/${var.namespace}/postgres.yml")
}


module "kes_app" {
  source = "../modules/kapp_app"

  namespace = var.namespace

  config_files  = list("${local.directories.vendor}/github.com/cloudfoundry/uaa/k8s")
  overlay_files = list("${local.directories.overlay}/${var.namespace}/uaa")
  values_files  = list("${local.directories.values}/${var.namespace}/uaa.yml")

  dependencies = [ module.uaa_db_chart.metadata ]
}