provider "vsphere" {
  user = "administrator@${var.domain}"
  password  = var.vcenter_password
  vsphere_server = "vcenter.${local.subdomain}"
}

provider "google" {
  credentials = file("${local.directories.secrets}/gcp-homelab-service-account.json")
  project     = "crdant-net"
  region      = "us-east-4"
}