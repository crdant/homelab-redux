data "terraform_remote_state" "infrastructure" {
  backend = "local"

  config = {
    path = "${path.module}/../infrastructure/terraform.tfstate"
  }
}

data "terraform_remote_state" "secrets" {
  backend = "local"

  config = {
    path = "${path.module}/../secrets/terraform.tfstate"
  }
}
