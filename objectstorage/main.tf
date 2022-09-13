module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.4.0"
  bucket = local.s3_bucket_name
  acl    = "private"
}

resource "aws_s3_object" "website" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = "/website/index.html"
  source = "../website/index.html"

  tags = local.common_tags
}

resource "aws_iam_role" "allow_ec2_s3" {
  name = "allow_ec2_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.common_tags
}

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_ec2_s3.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_ec2_s3.name

  tags = local.common_tags
}
