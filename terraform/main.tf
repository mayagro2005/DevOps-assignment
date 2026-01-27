# -----------------------------
# main.tf
# -----------------------------

# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Lookup the latest Amazon Linux 2 AMI for the chosen region
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# Security Group for EC2
resource "aws_security_group" "app_sg" {
  name = "java-app-sg"

  # Allow HTTP traffic on port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH for debugging if needed
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  security_groups = [aws_security_group.app_sg.name]

  # EC2 Instance
resource "aws_instance" "app" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              yum update -y

              # Install Docker
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker

              # Login to Docker Hub (for both docker and Watchtower)
              echo "${var.docker_token}" | docker login -u "${var.docker_username}" --password-stdin

              # Remove old app container if exists
              docker stop java-app || true
              docker rm java-app || true

              # Pull latest image explicitly
              docker pull ${var.docker_username}/java-devops-app:latest

              # Run app container
              docker run -d \
                --name java-app \
                --restart always \
                -p 8080:8080 \
                ${var.docker_username}/java-devops-app:latest

              # Remove old Watchtower if exists
              docker stop watchtower || true
              docker rm watchtower || true

              # Run Watchtower with Docker Hub credentials
              docker run -d \
                --name watchtower \
                --restart always \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -e REPO_USER=${var.docker_username} \
                -e REPO_PASS=${var.docker_token} \
                containrrr/watchtower \
                --interval 30 \
                --cleanup \
                java-app
              EOF

  tags = {
    Name = "java-devops-app"
  }
}


  tags = {
    Name = "java-devops-app"
  }
}

