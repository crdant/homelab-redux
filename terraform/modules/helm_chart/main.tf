resource "random_pet" "release" {
  count = var.release == "" ? 1 : 0
  length = 2
}

locals {
  release = var.release != "" ? var.release : random_pet.release[0].id
}

data "k14s_ytt" "values" {
    files = concat(var.values_files, var.secrets_files, var.overlay_files)
    values_yaml = var.values
    ignore_unknown_comments = true
}

resource "helm_release" "release" {
  count = length(var.dependencies) == 0 ? 1 : 1

  name       = local.release
  repository = var.repository
  chart      = var.chart 
  namespace  = var.namespace
 
  values = [
    data.k14s_ytt.values.result
  ]
}
