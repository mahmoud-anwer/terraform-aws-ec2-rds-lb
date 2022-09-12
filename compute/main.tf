data "terraform_remote_state" "objectstorage" {
  backend = "local"

  config = {
    path = "../objectstorage/terraform.tfstate"
  }
}

data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../networking/terraform.tfstate"
  }
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name = "web server"

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  key_name               = "terraform-key-00"
  monitoring             = false
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.nginx_sg]
  subnet_id              = data.terraform_remote_state.networking.outputs.vpc_public_subnets[0]
  iam_instance_profile   = data.terraform_remote_state.objectstorage.outputs.nginx_profile
  
  user_data = templatefile("./user_data.tpl", {
  s3_bucket_name = data.terraform_remote_state.objectstorage.outputs.s3_bucket_name })

  # user_data = <<-EOT
  # #! /bin/bash
  # sudo amazon-linux-extras install -y nginx1
  # sudo service nginx start
  # aws s3 cp s3://${data.terraform_remote_state.objectstorage.outputs.s3_bucket_name}/website/index.html /home/ec2-user/index.html
  # sudo rm /usr/share/nginx/html/index.html
  # sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
  # echo '<html><head><title>Testing Terraform</title></head><body<h1>Hello World!</h1></body></html>' | sudo tee /usr/share/nginx/html/index.html
  # EOT

  tags = local.common_tags
}