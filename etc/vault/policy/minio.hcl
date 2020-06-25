path "transit/datakey/plaintext/minio" {
  capabilities = [ "read", "update"]
}
path "transit/decrypt/minio" {
  capabilities = [ "read", "update"]
}
path "transit/rewrap/minio" {
  capabilities = ["update"]
}