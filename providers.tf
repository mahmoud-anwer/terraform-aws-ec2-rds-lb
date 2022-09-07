##################################################################################
# TERRAFORM CONFIG
##################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

  }
  backend "s3" {
    bucket = "terraform-state-2222"
    key    = "./terraform.tfstate"
    region = "us-east-1"
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.aws_region
}