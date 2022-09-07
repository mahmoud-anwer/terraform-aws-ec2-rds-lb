# Random ID for unique naming
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    company = var.company
    project = var.project
  }

  s3_bucket_name = lower("my-bucket-${random_integer.rand.result}")
}