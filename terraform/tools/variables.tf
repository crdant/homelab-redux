variable "email" {
    type = string
}

variable "project_root" {
    type = string
}

variable "namespace" {
    type = string
    default = "tools"
}

locals {
    subdomain = data.terraform_remote_state.infrastructure.outputs.subdomain
    ldap_host = "directory.${local.subdomain}"
    minio_host = "s3.${local.subdomain}"

    directories = {
        config = "${var.project_root}/config"
        values = "${var.project_root}/values"
        secrets = "${var.project_root}/secrets"
        policy  = "${var.project_root}/etc/vault/policy"
        overlay = "${var.project_root}/overlay"
    }

    helm = { 
        stable = "https://kubernetes-charts.storage.googleapis.com/"
        bitnami = "https://charts.bitnami.com/bitnami" 
        jetstack = "https://charts.jetstack.io"
    }
}
