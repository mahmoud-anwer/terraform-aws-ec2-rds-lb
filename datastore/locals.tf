locals {
  common_tags = {
    company = "Squadio"
    project = "Testing Terraform"
  }

  db_secret = {
    rds_master_password = "${random_password.default_password.result}"
  }
}