data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = "terraform-state-2222"
    key     = "testing/networking.tfstate"
    region  = "us-east-1"
  }
}