output "aws_alb_public_dns" {
  value = module.alb.lb_dns_name
}

# output "site_record" {
#   value = aws_route53_record.site_record.fqdn
# }