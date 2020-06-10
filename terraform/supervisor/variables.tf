variable "environment" {
    type = string
    default = ""
}

variable "email" {
    type = string
}

variable "project_root" {
    type = string
}

variable "default_namespace" {
    type = string
    default = "operations"
}

variable "secrets_namespace" {
    type = string
    default = "secrets"
}

variable "directory_namespace" {
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

resource "random_pet" "environment" {
    length = 2 
}

locals {
    environment = var.environment != "" ? var.environment : random_pet.environment.id
    dashed_environment = replace(local.environment, ".", "-")

    subdomain = "${local.environment}.${var.domain}"
    dashed_subdomain = replace(local.subdomain, ".", "-")
   
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