path "concourse/vsphere/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "concourse/runtime/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "concourse/pivnet/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

