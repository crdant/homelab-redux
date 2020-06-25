resource "random_pet" "release_name" {
    length = 2
}

locals {
  meta_values = {
    app = var.app != "" ? var.app : random_pet.release_name.id
  }  
}

data "k14s_ytt" "values" {
    files = concat(var.config_files, var.values_files, var.secrets_files, var.overlay_files)
    values_yaml = merge(local.meta_values, var.values)
    ignore_unknown_comments = true
}

resource "k14s_kapp" "application" {
  count = length(var.dependencies) == 0 ? 1 : 1

  app        = "${random_pet.release_name.id}"
  namespace  = var.namespace
  config_yaml = data.k14s_ytt.values.result
}
