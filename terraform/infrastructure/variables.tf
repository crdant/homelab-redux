variable "environment" {
    type = string
    default = ""
}

variable "email" {
    type = string
}

variable "vcenter_password" {
    type = string
}

variable "hypervisor_password" {
    type = string
}

variable "hypervisor_license" {
    type = string
}

variable "hypervisor6_license" {
    type = string
}

variable "project_root" {
    type = string
}

variable "domain" {
    type = string
}

resource "random_pet" "environment" {
    length = 2 
    separator = "."
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

variable "gcp_domain" {
    type = string
    default = ""
}

variable "gcp_project" {
    type = string
}

locals {
    environment = var.environment != "" ? var.environment : random_pet.environment.id
    dashed_environment = replace(local.environment, ".", "-")

    subdomain = "${local.environment}.${var.domain}"
    dashed_subdomain = replace(local.subdomain, ".", "-")

    supervisor_host = "supervisor.${local.subdomain}"

    directories = {
        secrets = "${var.project_root}/secrets"
    }

    gcp_domain = var.gcp_domain != "" ? var.gcp_domain : var.domain 
}