

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  subnets            = data.terraform_remote_state.networking.outputs.vpc_public_subnets
  security_groups    = [data.terraform_remote_state.networking.outputs.alb_sg]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = data.terraform_remote_state.compute.outputs.instance_id
          port = 80
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = local.common_tags
}