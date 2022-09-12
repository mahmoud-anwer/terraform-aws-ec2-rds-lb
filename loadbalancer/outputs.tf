output "aws_alb_public_dns" {
  value = module.alb.lb_dns_name
}