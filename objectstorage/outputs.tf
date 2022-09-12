output "s3_bucket_name" {
  value = local.s3_bucket_name
}

output "nginx_profile" {
  value = aws_iam_instance_profile.nginx_profile.name
}