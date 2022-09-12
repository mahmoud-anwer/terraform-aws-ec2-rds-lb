# Random ID for unique naming
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    company = "Squadio"
    project = "Testing Terraform"
  }

  s3_bucket_name = lower("my-bucket-${random_integer.rand.result}")
}
