variable "email" {
    type = string
}

variable "project_root" {
    type = string
}

variable "namespace" {
    type = string
    default = "operations"
}

variable "domain" {
    type = string
}

variable "gcp_domain" {
    type = string
    default = ""
}

variable "gcp_project" {
    type = string
}

variable "gcp_key_file" {
    type = string
}

variable "vault_ldap_bind_dn" {
    type = string
}

variable "vault_ldap_bind_password" {
    type = string
}

locals {
    base_dn = format("dc=%s", join(",dc=",split(".",var.domain)))
    subdomain = "lab.${var.domain}"
    ldap_host = "directory.${local.subdomain}"

    directories = {
        config = "${var.project_root}/config"
        values = "${var.project_root}/values"
        secrets = "${var.project_root}/secrets"
        policy  = "${var.project_root}/etc/vault/policy"
        overlay = "${var.project_root}/overlay"
        vendor = "${var.project_root}/vendor"
    }

    helm = { 
        stable = "https://kubernetes-charts.storage.googleapis.com/"
        bitnami = "https://charts.bitnami.com/bitnami" 
    }
    
    gcp_domain = var.gcp_domain != "" ? var.gcp_domain : var.domain 
}