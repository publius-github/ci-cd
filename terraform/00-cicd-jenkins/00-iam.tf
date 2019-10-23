resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_profile"
  role = "${aws_iam_role.jenkins_role.name}"
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_role"

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
}

resource "aws_iam_policy" "jenkins_policy" {
  name        = "jenkins_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "ecr:*",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "jenkins_policy_attach" {
  name       = "attachment"
  roles      = ["${aws_iam_role.jenkins_role.name}"]
  policy_arn = "${aws_iam_policy.jenkins_policy.arn}"
}