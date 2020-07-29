resource "vsphere_resource_pool" "nsx" {
  name                    = "nsx"
  parent_resource_pool_id = "${data.vsphere_compute_cluster.homelab.resource_pool_id}"
}

