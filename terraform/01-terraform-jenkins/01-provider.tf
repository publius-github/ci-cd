provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "ci-cd-bucket-125845703452"
    key    = "terraform-jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}
