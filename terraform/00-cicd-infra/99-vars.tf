variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}
