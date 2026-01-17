variable "aws_region" {
  description = "AWS region to deploy the EC2 instance"
  default     = "eu-north-1"
}

variable "docker_image" {
  description = "Docker image to run on EC2"
  default     = "mayagro2005/java-devops-app:latest"
}
