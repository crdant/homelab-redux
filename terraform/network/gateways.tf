resource "nsxt_policy_tier0_gateway" "k8s" {
  display_name              = "k8s-tier-0"
  failover_mode             = "NON_PREEMPTIVE"
  ha_mode                   = "ACTIVE_STANDBY"
  edge_cluster_path         = data.nsxt_policy_edge_cluster.edge_cluster.path
}