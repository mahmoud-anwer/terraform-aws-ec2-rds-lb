output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "rds_sg" {
  value = aws_security_group.rds_sg.id
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}