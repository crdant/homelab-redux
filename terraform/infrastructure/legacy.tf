resource "vsphere_host" "scotch" { 
  hostname = "scotch.lab.crdant.net"
  username = "root"
  password = var.hypervisor_password
  license  = var.hypervisor6_license
  datacenter = data.vsphere_datacenter.garage.id
}

resource "vsphere_distributed_virtual_switch" "legacy" {
  name          = "legacy"
  version       = "6.5.0"
  datacenter_id = "${data.vsphere_datacenter.garage.id}"
  max_mtu       = 2000

  host {
    host_system_id = vsphere_host.scotch.id
    devices = [ "vmnic0" ]
  }
}

resource "vsphere_distributed_port_group" "legacy_infra" {
  name                            = "legacy-infra-pg"
  distributed_virtual_switch_uuid = "${vsphere_distributed_virtual_switch.legacy.id}"

  vlan_id = 101
}

resource "vsphere_distributed_port_group" "legacy_witness" {
  name                            = "legacy-witness-pg"
  distributed_virtual_switch_uuid = "${vsphere_distributed_virtual_switch.legacy.id}"

  vlan_id = 102
}