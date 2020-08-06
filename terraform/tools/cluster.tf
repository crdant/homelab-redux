# resource "kubernetes_manifest" "cluster" {
#  provider = kubernetes-alpha
#  manifest = yamldecode(file("${path.module}/cluster.yml"))
#}

resource "kubernetes_cluster_role_binding" "default_psp" {
  provider = kubernetes.tools_cluster

  metadata {
    name = "clusterrolebinding-default-restricted-sa"
  }
  role_ref {
    kind = "ClusterRole"
    name = "psp:vmware-system-restricted"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind = "Group"
    name = "system:serviceaccounts"
    api_group = "rbac.authorization.k8s.io"
  }

}
