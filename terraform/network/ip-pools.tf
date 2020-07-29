resource "nsxt_ip_pool" "edge_tep" {
  display_name = "edge-tep-pool"

  subnet {
    allocation_ranges = ["10.22.1.1-10.22.254.254" ]
    cidr              = "10.22.0.0/16"
    gateway_ip        = "10.22.0.1"
    dns_suffix        = "lab.crdant.net"
    dns_nameservers   = [ "10.22.0.1" ]
  }

  tag {
    scope = "policyPath" 
    tag   = "/infra/ip-pools/edge-tep-pool" 
  }
}

resource "nsxt_ip_pool" "host_tep" {
  display_name = "host-tep-pool"

  subnet {
    allocation_ranges = ["10.20.1.1-10.20.254.254" ]
    cidr              = "10.20.0.0/16"
    gateway_ip        = "10.20.0.1"
    dns_suffix        = "lab.crdant.net"
    dns_nameservers   = [ "10.20.0.1" ]
  }

  tag {
    scope = "policyPath" 
    tag   = "/infra/ip-pools/esxi-tep-pool" 
  }
}