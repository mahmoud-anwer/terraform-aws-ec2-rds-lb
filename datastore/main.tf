data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../networking/terraform.tfstate"
  }
}

# I can't destroy the RDS because of the final snapshot
module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "~> 5.0.0"
  identifier = "my-rds"

  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "test"
  username = "user"
  password = var.rds_password
  port     = "3306"

  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.rds_sg]

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids = [data.terraform_remote_state.networking.outputs.vpc_private_subnets[0], data.terraform_remote_state.networking.outputs.vpc_private_subnets[1]]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = true

  tags = local.common_tags
}