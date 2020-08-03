# resource "kubernetes_manifest" "cluster" {
#  provider = kubernetes-alpha
#  manifest = yamldecode(file("${path.module}/cluster.yml"))
#}

resource "null_resource" "supervisor_cluster" {
  provisioner "local-exec" { 
    command = "tkg add management-cluster && tkg set management-cluster supervisor.lab.crdant.net"
  }
} 

resource "null_resource" "tools_cluster" {
  provisioner "local-exec" { 
    command = "tkg create cluster ${var.cluster_name} --plan=${var.cluster_plan} --namespace=${var.namespace} --kubernetes-version=${var.kubernetes_version} --worker-machine-count=${var.worker_nodes}"
    environment = {
      CONTROL_PLANE_STORAGE_CLASS = var.storage_class
      WORKER_STORAGE_CLASS = var.storage_class
      DEFAULT_STORAGE_CLASS = var.storage_class
      STORAGE_CLASSES = var.storage_class
      CONTROL_PLANE_VM_CLASS = var.control_plane_vm_class
      WORKER_VM_CLASS = var.worker_vm_class
      SERVICE_CIDR = var.services_cidr
      CLUSTER_CIDR = var.cluster_cidr
    }
  }

  depends_on = [
    null_resource.supervisor_cluster
  ]
} 

data "kubernetes_secret" "kubeconfig" {
  provider = kubernetes.supervisor_cluster

  metadata {
    name = "${var.cluster_name}-kubeconfig"
    namespace = var.namespace
  }

  depends_on = [
    null_resource.tools_cluster
  ]
}

resource "local_file" "kubeconfig" {
  content = data.kubernetes_secret.kubeconfig.data.value
  file_permission = "0600"
  filename = "${local.directories.secrets}/${var.cluster_name}.kubeconfig"
}

