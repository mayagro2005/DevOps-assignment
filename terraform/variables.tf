variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "docker_image" {
  description = "Docker image to run on EC2"
  type        = string
}

variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

variable "docker_password" {
  description = "Docker Hub password or token"
  type        = string
}