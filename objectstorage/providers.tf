terraform {
  backend "s3" {
    bucket  = "terraform-state-2222"
    key     = "testing/objectstorage.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}