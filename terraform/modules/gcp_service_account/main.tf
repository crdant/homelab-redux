resource "google_service_account" "account" {
  account_id   = var.account_id 
  display_name = var.display_name
  description  = var.description
}

resource "google_project_iam_member" "roles" {
  count = length(var.roles)

  role    = var.roles[count.index]
  member  = "serviceAccount:${google_service_account.account.email}"
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.account.name
  depends_on = [ google_project_iam_member.roles ]
}

resource "kubernetes_secret" "credentials" {
  metadata {
    name = "${var.account_id}-gcp-credentials"
    namespace = var.namespace
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.key.private_key)
  }
}