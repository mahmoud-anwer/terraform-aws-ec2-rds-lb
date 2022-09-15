

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  for_each = toset(["1", "2"])

  name = "web server-${each.key}"
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  key_name               = "terraform-key-00"
  monitoring             = false
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.ec2_sg]
  subnet_id              = data.terraform_remote_state.networking.outputs.vpc_public_subnets[0]
  iam_instance_profile   = data.terraform_remote_state.objectstorage.outputs.nginx_profile
  
  user_data = templatefile("./user_data.tpl", {
  s3_bucket_name = data.terraform_remote_state.objectstorage.outputs.s3_bucket_name })

  tags = local.common_tags
}