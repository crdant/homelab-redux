module "rye_certificate" {
  source = "../modules/certificate"

  request = file("${local.directories.secrets}/rye.${local.subdomain}.csr")
  email = var.email
   
  gcp_service_account = module.dns_challenge_service_account.private_key
}

resource "local_file" "rye_certificate" {
  content = <<CHAIN
${module.rye_certificate.certificate}
CHAIN
  filename = "${local.directories.secrets}/rye.${local.subdomain}.crt"
}

module "bourbon_certificate" {
  source = "../modules/certificate"

  request = file("${local.directories.secrets}/bourbon.${local.subdomain}.csr")
  email = var.email
   
  gcp_service_account = module.dns_challenge_service_account.private_key
}

resource "local_file" "bourbon_certificate" {
  content = <<CHAIN
${module.bourbon_certificate.certificate}
CHAIN
  filename = "${local.directories.secrets}/bourbon.${local.subdomain}.crt"
}

module "scotch_certificate" {
  source = "../modules/certificate"

  request = file("${local.directories.secrets}/scotch.${local.subdomain}.csr")
  email = var.email
   
  gcp_service_account = module.dns_challenge_service_account.private_key
}

resource "local_file" "scotch_certificate" {
  content = <<CHAIN
${module.scotch_certificate.certificate}
CHAIN
  filename = "${local.directories.secrets}/scotch.${local.subdomain}.crt"
}

module "witness_certificate" {
  source = "../modules/certificate"

  request = file("${local.directories.secrets}/witness.${local.subdomain}.csr")
  email = var.email
   
  gcp_service_account = module.dns_challenge_service_account.private_key
}

resource "local_file" "witness_certificate" {
  content = <<CHAIN
${module.witness_certificate.certificate}
CHAIN
  filename = "${local.directories.secrets}/witness.${local.subdomain}.crt"
}