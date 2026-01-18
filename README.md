# Java DevOps Home Assignment

## Objective
This project demonstrates a complete DevOps workflow including:

- CI/CD automation with GitHub Actions
- Docker containerization
- Infrastructure provisioning with Terraform
- Deployment to AWS EC2

The application is deployed automatically on an EC2 instance and exposed on port **8080**.

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
4. EC2 installs Docker and runs the application container automatically on startup

---

## Prerequisites

Install the following tools locally:

- AWS account (Free Tier is sufficient)
- AWS CLI  
  https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
- Terraform  
  https://developer.hashicorp.com/terraform/downloads
- Git

> Docker, Java, and Maven are **not required locally**.

Docker image used by this project:
mayagro2005/java-devops-app:latest


This image is public and safe to use.

---

## Step 1: Create AWS IAM User (for Terraform)

Terraform needs permissions to create AWS resources in your account.

1. Login to AWS Management Console
2. Go to **IAM → Users → Create user**
3. User name: `terraform-user`
4. Select **Programmatic access**
5. Attach permission policy:
   - `AmazonEC2FullAccess`
6. Create the user
7. Save the **Access Key ID** and **Secret Access Key**

> You will not be able to view them again

---

## Step 2: Configure AWS Credentials Locally

Run the following command:

```bash
aws configure

Enter the values:

AWS Access Key ID:     <YOUR_ACCESS_KEY>
AWS Secret Access Key: <YOUR_SECRET_KEY>
Default region name:   eu-north-1
Default output format: json


Verify credentials:

aws sts get-caller-identity

Step 3: Initialize Terraform
   Navigate to the Terraform directory:
      cd terraform

   Initialize Terraform:
      terraform init


Step 4: Deploy Infrastructure with Terraform
Run:
terraform apply

Type:

yes


Terraform will:

   Create a Security Group (port 8080 open)
   Launch an EC2 instance
   Install Docker on the EC2 instance
   Pull the Docker image from Docker Hub
   Run the container automatically on startup

Step 5: Access the Application
   After deployment completes, Terraform outputs:
   app_url = "http://<EC2_PUBLIC_IP>:8080"


Open the URL in your browser:
   http://<EC2_PUBLIC_IP>:8080


Expected output:
   Hello from AWS DevOps Assignment!