data "terraform_remote_state" "infrastructure" {
  backend = "local"

  config = {
    path = "${path.module}/../infrastructure/terraform.tfstate"
  }
}

data "terraform_remote_state" "operations" {
  backend = "local"

  config = {
    path = "${path.module}/../operations/terraform.tfstate"
  }
}
