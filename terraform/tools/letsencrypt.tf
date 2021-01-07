data "k14s_ytt" "letsencrypt_manifest" {
    files = [
      "${local.directories.vendor}/github.com/crdant/ytt-lib/letsencrypt"
    ]
    values = {
      "namespace" = kubernetes_namespace.cert_manager.metadata[0].name
      "certmanager.solver.clouddns.keyfile" = data.terraform_remote_state.infrastructure.outputs.dns_challenge_account_private_key
    }
    ignore_unknown_comments = true
}

/*
resource "kubernetes_manifest" "letsencrypt" {
  provider = kubernetes-alpha
  manifest = yamldecode(data.k14s_ytt.letsencrypt_manifest.result)
}
*/

output "letsencrypt_manifest" {
  value = data.k14s_ytt.letsencrypt_manifest.result
}