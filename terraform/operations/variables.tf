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
    subdomain = "lab.${var.domain}"
    ldap_host = "directory.${local.subdomain}"
   
    directories = {
        values = "${var.project_root}/values"
        secrets = "${var.project_root}/secrets"
        overlay = "${var.project_root}/overlay"
    }

    helm = { 
        stable = "https://kubernetes-charts.storage.googleapis.com/"
        bitnami = "https://charts.bitnami.com/bitnami" 
    }
    
    gcp_domain = var.gcp_domain != "" ? var.gcp_domain : var.domain 
}