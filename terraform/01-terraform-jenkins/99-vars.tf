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

variable "public_key_path" {
  type = "string"

  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "private_key_path" {
  type = "string"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "tf_key"
}

variable "ip_white_list" {
  type    = "list"
  default = ["93.125.8.133/32", "10.0.0.0/16", "93.85.92.82/32", "213.184.244.188/32", "82.209.241.194/32", "0.0.0.0/0"]
}
