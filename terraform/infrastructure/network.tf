resource "vsphere_distributed_virtual_switch" "homelab" {
  name          = "homelab"
  datacenter_id = data.vsphere_datacenter.garage.id
  max_mtu       = 9000

  host {
    host_system_id = vsphere_host.rye.id
    devices = local.homelab_interfaces
  }


  host {
    host_system_id = data.vsphere_host.bourbon.id
    devices = local.homelab_interfaces
  }
}

resource "vsphere_distributed_port_group" "management" {
  name                            = "management-pg"
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.homelab.id

  vlan_id = 101
}

resource "vsphere_distributed_port_group" "witness" {
  name                            = "witness-pg"
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.homelab.id

  vlan_id = 102
}

resource "vsphere_distributed_virtual_switch" "motion" {
  name          = "motion"
  datacenter_id = data.vsphere_datacenter.garage.id
  max_mtu       = 9000

  host {
    host_system_id = vsphere_host.rye.id
    devices = local.vmotion_interfaces
  }


  host {
    host_system_id = data.vsphere_host.bourbon.id
    devices = local.vmotion_interfaces
  }
}

resource "vsphere_distributed_port_group" "motion" {
  name                            = "motion-pg"
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.motion.id
  vlan_id = 103
}

resource "vsphere_distributed_virtual_switch" "storage" {
  name          = "storage"
  datacenter_id = data.vsphere_datacenter.garage.id
  max_mtu       = 9000

  host {
    host_system_id = vsphere_host.rye.id
    devices = local.vsan_interfaces
  }


  host {
    host_system_id = data.vsphere_host.bourbon.id
    devices = local.vsan_interfaces
  }
}

resource "vsphere_distributed_port_group" "storage" {
  name                            = "storage-pg"
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.storage.id
  vlan_id = 102
}
