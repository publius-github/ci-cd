resource "aws_iam_role" "fargate-ecr-role" {
  name = "fargate-ecr-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com",
          "ecs-tasks.amazonaws.com",
          "ecs.application-autoscaling.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "fargate-ecr-policy" {
  name = "fargate-ecr-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "fargate-ecs-policy" {
  name = "fargate-ecs-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "fargate-attach" {
  role       = "${aws_iam_role.fargate-ecr-role.name}"
  policy_arn = "${aws_iam_policy.fargate-ecr-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "fargate-attach2" {
  role       = "${aws_iam_role.fargate-ecr-role.name}"
  policy_arn = "${aws_iam_policy.fargate-ecs-policy.arn}"
}
