resource "kubernetes_namespace" "registry" {
  provider = kubernetes.tools_cluster
  metadata {
    name = "registry"
  }

  depends_on = [
    local_file.kubeconfig
  ]
}

resource "random_password" "admin" {
  length = 20
  min_upper = 2
  min_lower = 2
  min_numeric = 2
  min_special = 2
}

resource "random_password" "secret_key" {
  length = 16
  override_special = "!@#$%&()-_=+[]{}<>?"
}

resource "random_password" "core_secret" {
  length = 16
  override_special = "!@#$%&()-_=+[]{}<>?"
}

resource "random_pet" "database_password" {
  length = 5
}

module "harbor_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.jetstack
  chart = "harbor"
  namespace = kubernetes_namespace.registry.metadata.0.name

  values = {
    "subdomain" = local.subdomain
    "harborAdminPassword" = random_password.admin.result
    "secretKey" = random_password.secret_key.result
    "core.secret" = random_password.core_secret.result
    "s3.host" = data.terraform_remote_state.operations.outputs.minio_host
    "s3.accessKey" = data.kubernetes_secret.minio_access_key.data.access-key
    "s3.secretKey" = data.kubernetes_secret.minio_access_key.data.secret-key
    "postgres.password" = random_pet.database_password.id
  }
  values_files = list("${local.directories.values}/${var.namespace}/harbor.yml")
  overlay_files = list("${local.directories.overlay}/${var.namespace}/harbor")

  providers = {
    helm = helm.tools_cluster
  }
}
