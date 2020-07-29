provider "vsphere" {
  user = "administrator@${var.domain}"
  password  = var.vcenter_password
  vsphere_server = "vcenter.${local.subdomain}"
}

provider "nsxt" {
  allow_unverified_ssl     = true
  max_retries              = 10
  retry_min_delay          = 500
  retry_max_delay          = 5000
  retry_on_status_codes    = [429]
}

provider "google" {
  credentials = file("${local.directories.secrets}/gcp-homelab-service-account.json")
  project     = "crdant-net"
  region      = "us-east-4"
}