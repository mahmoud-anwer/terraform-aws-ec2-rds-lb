terraform {

  required_version = ">= 1.0.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.30.0"
    }
  }

  backend "s3" {
    bucket  = "terraform-state-2222"
    key     = "testing/loadbalancer.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}