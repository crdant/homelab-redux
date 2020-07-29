data "vsphere_datacenter" "garage" {
  name = "garage"
}

data "vsphere_compute_cluster" "homelab" {
  name = "homelab"
  datacenter_id = data.vsphere_datacenter.garage.id
}