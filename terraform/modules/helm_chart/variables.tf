variable "namespace" {
    type = string
}

variable "repository" {
    type = string
    default = "https://charts.bitnami.com/bitnami"
}

variable "chart" {
    type = string
}

variable "release" {
    type = string
    default = ""
}

variable "values" {
    type = map
    default = {}
}

variable "values_files" {
    type = list
    default = []
}

variable "secrets_files" {
    type = list
    default = []
}

variable "overlay_files" {
    type = list
    default = []
}

variable "dependencies" { 
    type = any
    default = []
}