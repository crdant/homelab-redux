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

locals {
    subdomain = data.terraform_remote_state.infrastructure.outputs.subdomain
    gcp_domain = data.terraform_remote_state.infrastructure.outputs.gcp_domain
    gcp_project = data.terraform_remote_state.infrastructure.outputs.gcp_project
   
    directories = {
        values = "${var.project_root}/values"
        secrets = "${var.project_root}/secrets"
        overlay = "${var.project_root}/overlay"
    }

    helm = { 
        hashicorp = "https://helm.releases.hashicorp.com"
    }
}