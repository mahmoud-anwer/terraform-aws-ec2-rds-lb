#################################################################################################
###       SECRET MANAGER
###   Generate random password for RDS and add it to secret manager
#################################################################################################

resource "random_password" "default_password" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "secretmanager" {
  name        = var.secret
  description = "This secret is for rds master password"
  recovery_window_in_days = 0
  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id     = aws_secretsmanager_secret.secretmanager.id
  secret_string = jsonencode(local.db_secret)
  # secret_string = jsonencode({"rds_master_password": "${random_password.default_password.result}"})
}

#################################################################################################
###     RDS
#################################################################################################
module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "~> 5.0.0"
  identifier = var.identifier_name

  engine            = var.engine_type
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.db_size

  db_name  = var.db_name
  username = var.db_user
  create_random_password = false
  password = jsondecode(aws_secretsmanager_secret_version.secret_value.secret_string)["rds_master_password"]
  # password = random_password.default_password.result
  # password = local.db_secret["rds_master_password"]
  port     = var.db_port

  

  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.rds_sg]

  # DB subnet group
  create_db_subnet_group          = true
  subnet_ids                      = [data.terraform_remote_state.networking.outputs.vpc_private_subnets[0], data.terraform_remote_state.networking.outputs.vpc_private_subnets[1]]
  db_subnet_group_name            = var.subnet_group_name
  db_subnet_group_use_name_prefix = false

  # DB parameter group
  family                          = var.parameter_group_family
  parameter_group_name            = var.parameter_group_name
  parameter_group_use_name_prefix = false
  parameters = [
    {
      name  = "time_zone"
      value = "Asia/Riyadh"
    }
  ]

  # DB option group
  major_engine_version         = var.option_group_version
  option_group_name            = var.option_group_name
  option_group_use_name_prefix = false

  # Database Deletion Protection
  deletion_protection = false

  skip_final_snapshot = true

  tags = local.common_tags
}