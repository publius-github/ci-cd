provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"

}

terraform {
  backend "s3" {
    bucket = "ci-cd-bucket-125845703452"
    key    = "terraform-jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}
