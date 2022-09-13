data "terraform_remote_state" "objectstorage" {
  backend = "s3"
  config = {
    bucket  = "terraform-state-2222"
    key     = "testing/objectstorage.tfstate"
    region  = "us-east-1"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = "terraform-state-2222"
    key     = "testing/networking.tfstate"
    region  = "us-east-1"
  }
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}