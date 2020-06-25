module "uaa_db_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.bitnami
  chart = "postgresql"
  namespace = "operations"

  values_files = list("${local.directories.values}/${var.namespace}/postgres.yml")
}
