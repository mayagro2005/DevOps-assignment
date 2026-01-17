# Java DevOps Home Assignment

## Objective
This project demonstrates a complete DevOps workflow including:

- CI/CD automation (GitHub Actions)
- Docker containerization
- Infrastructure provisioning with Terraform
- Deployment to AWS EC2

The application is deployed automatically on an EC2 instance and exposed on port 8080.

---

## Architecture Overview
1. Code is pushed to GitHub
2. GitHub Actions:
   - Builds the Java application using Maven
   - Runs unit tests
   - Builds a Docker image
   - Pushes the image to Docker Hub
3. Terraform provisions AWS infrastructure:
   - EC2 instance (Amazon Linux)
   - Security Group allowing traffic on port 8080
4. EC2 installs Docker and runs the application container on startup

---

## Prerequisites
To run this project, you need:

- AWS account (Free Tier)
- Terraform installed (https://developer.hashicorp.com/terraform/downloads)
- Git installed
- Access to the public Docker image on Docker Hub (`yourusername/java-devops-app:latest`)

> No local Java, Maven, or Docker installation is required.

---

## Step 1: Configure AWS credentials

Terraform needs AWS credentials to create resources in your own account.

1. Create an AWS IAM user in your account:
   - Sign in to AWS Management Console → IAM → Users → Add user
   - Username: `terraform-user` (any name)
   - Access type: **Programmatic access**
   - Permissions: Attach **AmazonEC2FullAccess** (Free Tier)
   - Save **Access Key ID** and **Secret Access Key**

2. Configure AWS CLI locally:

```bash
aws configure

Enter the credentials you just created:

AWS Access Key ID: <your access key>
AWS Secret Access Key: <your secret key>
Default region name: us-east-1
Default output format: json