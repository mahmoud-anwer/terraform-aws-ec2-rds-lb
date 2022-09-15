########################################################################################################
#   Add record to ROUTE 53
#   terraform-task.example.com    CNAME   my-alb-********.us-east-1.elb.amazonaws.com
########################################################################################################
# resource "aws_route53_record" "site_record" {
#   name    = "terraform-task"
#   type    = "CNAME"
#   zone_id = "Z07852772N6SI4IJ5H9ZJ"
#   records = ["${module.alb.lb_dns_name}"]
#   ttl     = 60
# }
########################################################################################################
#   LOAD BALANCER
########################################################################################################
 
module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "7.0.0"
  name               = "my-alb"
  load_balancer_type = "application"
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  subnets            = data.terraform_remote_state.networking.outputs.vpc_public_subnets
  security_groups    = [data.terraform_remote_state.networking.outputs.alb_sg]

  target_groups = [
    {
      name = "my-tg"
      # name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      #   Working with two instances into my target group
      targets = {
        ec2_1 = {
          target_id = data.terraform_remote_state.compute.outputs.instance_1_id
          # I think I can remove this port the next time I will deploy because I already have the backend_port configured
          port      = 80
        },
        ec2_2 = {
          target_id = data.terraform_remote_state.compute.outputs.instance_2_id
          port      = 80
        }
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
      target_group_index = 0
      #===============================
      # Requests otherwise not routed
      #===============================
      action_type = "fixed-response"
      fixed_response = {
        status_code  = "503"
        content_type = "text/plain"
      }
      #===============================
    }
  ]

  https_listener_rules = [
    {
      http_tcp_listener_index = 0
      # priority              = 5000
      actions = [{
        type = "forward"
        target_groups = [
          {
            target_group_index = 1
        }]
        stickiness = {
          enabled  = true
          duration = 3600
        }
      }]
      conditions = [{
        host_headers = ["terraform-task.ibtik.com"]
      }]
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      #===============================
      # Requests otherwise not routed
      #===============================
      action_type = "fixed-response"
      fixed_response = {
        status_code  = "503"
        content_type = "text/plain"
      }
      #===============================
    }
  ]

  http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      # priority                = 5000
      actions = [{
        type        = "redirect"
        status_code = "HTTP_301"
        port        = "443"
        protocol    = "HTTPS"
      }]

      conditions = [{
        host_headers = ["*.ibtik.com"]
      }]
    }
  ]

  tags = local.common_tags
}