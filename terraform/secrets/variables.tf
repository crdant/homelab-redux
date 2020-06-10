variable "email" {
    type = string
}

variable "project_root" {
    type = string
}

variable "namespace" {
    type = string
    default = "secrets"
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

locals {
    subdomain = "lab.${var.domain}"
   
    directories = {
        values = "${var.project_root}/values"
        secrets = "${var.project_root}/secrets"
        overlay = "${var.project_root}/overlay"
    }

    helm = { 
        hashicorp = "https://helm.releases.hashicorp.com"
    }
    
    gcp_domain = var.gcp_domain != "" ? var.gcp_domain : var.domain 
}