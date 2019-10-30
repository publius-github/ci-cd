resource "aws_ecr_repository" "cicd_jenkins" {
  name = "cicd-jenkins"
}

resource "aws_ecr_repository" "cicd_sonar" {
  name = "cicd-sonar-runner"
}

resource "aws_ecr_repository" "simple_testing_capabilities" {
  name = "simple-testing-capabilities"
}

resource "aws_ecr_repository" "simple_testing_capabilities_spa" {
  name = "simple-testing-capabilities-spa"
}
