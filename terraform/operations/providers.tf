provider "google" {
  credentials = file("${local.directories.secrets}/gcp-homelab-service-account.json")
  project     = "crdant-net"
  region      = "us-east-4"
}