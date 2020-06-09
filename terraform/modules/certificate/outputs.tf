output "secret" {
    value = kubernetes_secret.tls_secret.metadata[0].name
}

output "certificate" {
    value = acme_certificate.certificate.certificate_pem
    depends_on = [ kubernetes_secret.tls_secret ]
}

output "issuer" {
    value = acme_certificate.certificate.issuer_pem
    depends_on = [ kubernetes_secret.tls_secret ]
}
