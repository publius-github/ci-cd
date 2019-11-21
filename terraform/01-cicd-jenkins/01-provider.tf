provider "aws" {
  #  access_key = "${var.aws_access_key}"
  #  secret_key = "${var.aws_secret_key}"
  profile = "godel"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "cicd-tfstate-5342"
    key    = "01-cicd-jenkins/terraform.tfstate"
    region = "us-east-1"
    encrypt = false
    acl = "bucket-owner-full-control"
  }
}
