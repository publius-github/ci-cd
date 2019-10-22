resource "aws_ecr_repository" "ecr" {
  name = "cicd-jenkins"
}

resource "aws_ecr_repository" "ecr" {
  name = "cicd-sonar"
}

resource "aws_ecr_repository" "ecr" {
  name = "simple-testing-capabilities"
}

resource "aws_ecr_repository" "ecr" {
  name = "simple-testing-capabilities-spa"
}
