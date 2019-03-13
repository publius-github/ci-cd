resource "aws_s3_bucket" "b" {
  bucket = "jenkins_bucket"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.b.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::jenkins_bucket/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "213.184.244.188/32", "82.209.241.194/32"}
      }
    }
  ]
}
POLICY
}