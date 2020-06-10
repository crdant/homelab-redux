
variable "email" {
    type = string
    default = ""
}

variable "namespace" {
    type = string
    default = ""
}

variable "host" {
    type = string
    default = ""
}

variable "alternates" {
    type = "list"
    default = []
}

variable "gcp_service_account" {
    type = string
    default = ""
}

variable "request" {
    type = string
    default = ""
}