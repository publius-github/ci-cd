# resource "aws_iam_policy" "access_policy" {
#   name = "github_policy"
resource "aws_iam_role" "ecsTaskExecutionRole" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "s3.amazonaws.com",
            "ec2.amazonaws.com",
            "cloudtrail.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}

EOF
}
