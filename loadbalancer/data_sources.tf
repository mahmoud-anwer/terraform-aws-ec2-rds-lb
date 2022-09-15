data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "terraform-state-2222"
    key    = "testing/networking.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = "terraform-state-2222"
    key    = "testing/compute.tfstate"
    region = "us-east-1"
  }
}