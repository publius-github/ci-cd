variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "app_image_backend" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_image_frontend" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_port_backend" {
  description = "Port exposed by the docker image to redirect traffic to"
}

variable "app_port_frontend" {
  description = "Port exposed by the docker image to redirect traffic to"
}


variable "app_cpu_backend" {
  default = 1024
}

variable "app_cpu_frontend" {
  default = 1024
}

variable "app_memory_backend" {
  default = 2048
}

variable "app_memory_frontend" {
  default = 2048
}
