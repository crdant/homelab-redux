data "vsphere_host" "rye" { 
  name = "rye.lab.crdant.net"
  datacenter_id = data.vsphere_datacenter.garage.id
}

resource "vsphere_host" "bourbon" { 
  hostname = "bourbon.lab.crdant.net"
  username = "root"
  password = var.hypervisor_password
  license  = var.hypervisor_license
  cluster = data.vsphere_compute_cluster.homelab.id
}

locals {
  host_names = [ vsphere_host.bourbon.hostname, data.vsphere_host.rye.name ]
  host_ids = [ vsphere_host.bourbon.id, data.vsphere_host.rye.id ]
  homelab_interfaces = [
    "vmnic0",
    "vmnic1",
    "vmnic3",
  ]
  vmotion_interfaces = [
    "vmnic6"
  ]
  vsan_interfaces = [
    "vmnic7"
  ]
}

resource "vsphere_vnic" "witness" {
  count = length(local.host_ids)

  host                    = local.host_ids[count.index]
  distributed_switch_port = vsphere_distributed_virtual_switch.homelab.id
  distributed_port_group  = vsphere_distributed_port_group.witness.id
  ipv4 {
    dhcp = true
    gw = "10.18.2.1"
  }

  netstack = "defaultTcpipStack"
  
  provisioner "remote-exec" {
    inline = [
      "esxcli vsan network ip add -i ${split("_",self.id)[1]} -T=witness"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      password = var.hypervisor_password
      host     = local.host_names[count.index]
    }
  }
}

resource "vsphere_vnic" "storage" {
  count = length(local.host_ids)

  host                    = local.host_ids[count.index]
  distributed_switch_port = vsphere_distributed_virtual_switch.storage.id
  distributed_port_group  = vsphere_distributed_port_group.storage.id

  ipv4 {
    ip = cidrhost("10.18.2.0/24", 200+((count.index+1)*10))
    netmask = "255.255.255.0"
  }
  netstack = "defaultTcpipStack"

	provisioner "remote-exec" {
		inline = [
			"esxcli vsan network ip add -i ${split("_",self.id)[1]} -T=vsan"
		]

		connection {
			type     = "ssh"
			user     = "root"
			password = var.hypervisor_password
			host     = local.host_names[count.index]
		}
	}


  depends_on = [ vsphere_vnic.witness ]
}

resource "vsphere_vnic" "motion" {
  count = length(local.host_ids)

  host                    = local.host_ids[count.index]
  distributed_switch_port = vsphere_distributed_virtual_switch.motion.id
  distributed_port_group  = vsphere_distributed_port_group.motion.id
  
  ipv4 {
    ip = cidrhost("10.18.3.0/24", 200+((count.index+1)*10))
    netmask = "255.255.255.0"
  }
  netstack = "vmotion"

  depends_on = [ vsphere_vnic.storage ]
}