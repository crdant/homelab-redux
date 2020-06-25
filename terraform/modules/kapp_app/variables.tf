variable "namespace" {
    type = string
}

variable "app" {
    type = string
    default = ""
}

variable "config_files" {
    type = list 
}

variable "overlay_files" {
    type = list 
    default = []
}

variable "values_files" {
    type = list
    default = []
}

variable "secrets_files" {
    type = list
    default = []
}

variable "values" {
    type = map
    default = {}
}

variable "dependencies" { 
    type = any
    default = []
}