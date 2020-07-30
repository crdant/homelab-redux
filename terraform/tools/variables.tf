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

variable "kubeconfig" {
    type = string
}

variable "cluster_name" {
    type = string
    default = "tools"
}

variable "cluster_plan" {
    type = string
    default = "dev"
}

variable "worker_nodes" {
    type = number
    default = 3
}

variable "kubernetes_version" {
    type = string
    default = "v1.17.7+vmware.1"
}


variable "control_plane_vm_class" { 
    type = string
    default = "best-effort-small"
}

variable "worker_vm_class" { 
    type = string
    default = "best-effort-medium"
}

variable "storage_class" {
    type = string
    default = "vsan"
}

variable "services_cidr" {
    type = string
    default = "10.208.0.0/12"
}

variable "cluster_cidr" {
    type = string
    default = "172.18.0.0/16"
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
    }
}
