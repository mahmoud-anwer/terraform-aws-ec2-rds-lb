module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "~> 5.0.0"
  identifier = "my-db"


  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "test"
  username = "user"
  password = var.rds_password 
  port     = "3306"

  #   iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  #   maintenance_window = "Mon:00:00-Mon:03:00"
  #   backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  #   monitoring_interval = "30"
  #   monitoring_role_name = "MyRDSMonitoringRole"
  #   create_monitoring_role = true


  # DB subnet group
  create_db_subnet_group = true
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
   major_engine_version = "8.0"

  # Database Deletion Protection
#   deletion_protection = false
  deletion_protection = true

  #   parameters = [
  #     {
  #       name = "character_set_client"
  #       value = "utf8mb4"
  #     },
  #     {
  #       name = "character_set_server"
  #       value = "utf8mb4"
  #     }
  #   ]

  #   options = [
  #     {
  #       option_name = "MARIADB_AUDIT_PLUGIN"

  #       option_settings = [
  #         {
  #           name  = "SERVER_AUDIT_EVENTS"
  #           value = "CONNECT"
  #         },
  #         {
  #           name  = "SERVER_AUDIT_FILE_ROTATIONS"
  #           value = "37"
  #         },
  #       ]
  #     },
  #   ]

  tags = local.common_tags
}