resource "vsphere_folder" "homelab" {
  path          = "homelab"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.garage.id
}

resource "vsphere_folder" "infrastructure" {
  path          = "${vsphere_folder.homelab.path}/infrastructure"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.garage.id
}
