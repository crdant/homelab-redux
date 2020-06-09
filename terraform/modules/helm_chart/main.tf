resource "random_pet" "release_name" {
    length = 2
}

data "k14s_ytt" "values" {
    files = concat(var.values_files, var.secrets_files, var.overlay_files)
    values = var.values
    ignore_unknown_comments = true
}

resource "helm_release" "release" {
  count = length(var.dependencies) == 0 ? 1 : 1

  name       = random_pet.release_name.id
  repository = var.repository
  chart      = var.chart 
  namespace  = var.namespace
 
  values = [
    data.k14s_ytt.values.result
  ]
}
