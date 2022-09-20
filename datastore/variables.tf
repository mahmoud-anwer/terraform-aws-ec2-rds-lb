

variable "secret" {
  type    = string
  default = "terraform-tst-01"
}

variable "identifier_name" {
  type        = string
  description = "Name of database engine"
  default     = "my-rds"
}

variable "engine_type" {
  description = "Database Engine Type"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "version of database engine"
  type        = string
  default     = "8.0.23"
}

variable "instance_class" {
  description = "Database Instance Type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_size" {
  type        = number
  description = "Database instance disk size"
  default     = 10
}

variable "db_name" {
  type    = string
  default = "test"
}

variable "db_user" {
  type    = string
  default = "user"
}

variable "db_port" {
  type        = number
  description = "Database Port"
  default     = 3306
}

variable "subnet_group_name" {
  type        = string
  description = "Name of Subnet Group"
  default     = "test"
}

variable "parameter_group_family" {
  type        = string
  description = "Parameter Group Family"
  default     = "mysql8.0"
}

variable "parameter_group_name" {
  type        = string
  description = "Name of Parameter Group"
  default     = "test-mysql-8"
}

variable "option_group_version" {
  description = "Option Group Version"
  type        = string
  default     = "8.0"
}

variable "option_group_name" {
  description = "Name of Option Group"
  type        = string
  default     = "test-mysql-8"
}
