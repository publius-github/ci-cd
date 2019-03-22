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
# resource "aws_ecr_repository_policy" "foopolicy" {
#   repository = "${aws_ecr_repository.foo.name}"

#   policy = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#         {
#             "Sid": "new policy",
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": [
#                 "ecr:GetDownloadUrlForLayer",
#                 "ecr:BatchGetImage",
#                 "ecr:BatchCheckLayerAvailability",
#                 "ecr:PutImage",
#                 "ecr:InitiateLayerUpload",
#                 "ecr:UploadLayerPart",
#                 "ecr:CompleteLayerUpload",
#                 "ecr:DescribeRepositories",
#                 "ecr:GetRepositoryPolicy",
#                 "ecr:ListImages",
#                 "ecr:DeleteRepository",
#                 "ecr:BatchDeleteImage",
#                 "ecr:SetRepositoryPolicy",
#                 "ecr:DeleteRepositoryPolicy"
#             ]
#         }
#     ]
# }
# EOF
# }

            # "ecr.amazonaws.com",
            # "cloudtrail.amazonaws.com"
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ecr:*",
#                 "cloudtrail:LookupEvents"
#             ],
#             "Resource": "*"
#         }
#     ]
# }

# resource "aws_iam_role" "github-role" {
#   name = "github-backup"

#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": "sts:AssumeRole",
#             "Principal": {
#             "Service": [
#                 "s3.amazonaws.com",
#                 "lambda.amazonaws.com",
#                 "ecs.amazonaws.com"
#             ]
#             },
#             "Effect": "Allow",
#             "Sid": ""
#         }
#     ]
# }
# EOF
# }


# resource "aws_iam_role_policy_attachment" "test-attach" {
#     role       = "${aws_iam_role.github-role.name}"
#     policy_arn = "${aws_iam_policy.access_policy.arn}"
# }