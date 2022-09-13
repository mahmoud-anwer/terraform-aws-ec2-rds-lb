terraform {
  backend "s3" {
    bucket  = "terraform-state-2222"
    key     = "testing/networking.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}