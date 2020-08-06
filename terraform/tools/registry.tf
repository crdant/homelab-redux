resource "kubernetes_namespace" "registry" {
  provider = kubernetes.tools_cluster
  metadata {
    name = "registry"
  }
}

resource "random_password" "registry_admin" {
  length = 20
  min_upper = 2
  min_lower = 2
  min_numeric = 2
  min_special = 2
  override_special = "!@#$%&()-_=+[]{}<>?"
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

resource "minio_iam_user" "harbor" {
  name = "harbor"
}

resource "minio_s3_bucket" "harbor" {
  bucket = "harbor-image-chart-storage"
  acl = "private"
}

resource "minio_iam_policy" "harbor" {
  name = "state-terraform-s3"
  policy= <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Sid":"HarborRegistryAccess",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "arn:aws:s3:::${minio_s3_bucket.harbor.id}/*"
    }
  ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "harbor" {
  user_name = minio_iam_user.harbor.id
  policy_name = minio_iam_policy.harbor.id
}

module "harbor_chart" {
  source = "../modules/helm_chart"

  repository  = local.helm.bitnami
  chart = "harbor"
  namespace = kubernetes_namespace.registry.metadata.0.name

  values = {
    "subdomain" = local.subdomain
    "harborAdminPassword" = random_password.registry_admin.result
    "core.secretKey" = random_password.secret_key.result
    "core.secret" = random_password.core_secret.result
    "s3.host" = data.terraform_remote_state.operations.outputs.minio_host
    "s3.bucket" = minio_s3_bucket.harbor.id
    "s3.accessKey" = minio_iam_user.harbor.name
    "s3.secretKey" = minio_iam_user.harbor.secret
    "postgres.password" = random_pet.database_password.id
  }
  values_files = list("${local.directories.values}/${var.namespace}/harbor.yml")
  overlay_files = list("${local.directories.overlay}/${var.namespace}/harbor")

  providers = {
    helm = helm.tools_cluster
  }
}
