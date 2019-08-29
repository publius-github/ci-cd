provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "ci-cd-bucket-125845703452"
    key    = "terraform-state/01-cicd-ecs.tfstate"
    region = "us-east-1"
  }
}
