
variable "email" {
    type = string
}

variable "namespace" {
    type = string
}

variable "host" {
    type = string
}

variable "alternates" {
    type = "list"
    default = []
}

variable "gcp_service_account" {
    type = string
}