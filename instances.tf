##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

##################################################################################
# RESOURCES
##################################################################################

# INSTANCES #
resource "aws_instance" "ec2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [module.s3_bucket]
  #   user_data = <<EOF
  # #! /bin/bash
  # sudo amazon-linux-extras install -y nginx1
  # sudo service nginx start
  # sudo rm /usr/share/nginx/html/index.html
  # echo '<html><head><title>Taco Team Server 1</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
  # EOF
  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
# sudo yum install mysql -y
sudo service nginx start
mysql -u user -p"62fKkxXuTHhfGEGa" -h ${module.db.db_instance_endpoint} --port 3306 > /home/ec2-user/db.html
aws s3 cp s3://${module.s3_bucket.s3_bucket_id}/website/index.html /home/ec2-user/index.html
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/db.html /usr/share/nginx/html/db.html
EOF

  # user_data = templatefile("${path.module}/startup_script.tpl", {
  #   s3_bucket_name = module.web_app_s3.web_bucket.id
  # })

  tags = local.common_tags

}