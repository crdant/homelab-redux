data "terraform_remote_state" "supervisor" {
  backend = "local"

  config = {
    path = "${path.module}/../supervisor/terraform.tfstate"
  }
}

data "terraform_remote_state" "secrets" {
  backend = "local"

  config = {
    path = "${path.module}/../secrets/terraform.tfstate"
  }
}
