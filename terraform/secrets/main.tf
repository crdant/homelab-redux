data "terraform_remote_state" "supervisor" {
  backend = "local"

  config = {
    path = "${path.module}/../supervisor/terraform.tfstate"
  }
}