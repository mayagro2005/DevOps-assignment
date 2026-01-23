Prerequisites

You only need Git installed locally.

No need to install Docker, Terraform, or AWS CLI — all is handled in GitHub Actions.

Secrets already in the GitHub repo:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_REGION

DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

These are used by GitHub Actions for all deployments and infrastructure provisioning.

Step 1: Bootstrap Terraform Backend (Manual, Only Once)

   Before the first deployment, you must create the Terraform backend:

   Go to GitHub → Actions → Terraform Bootstrap

   Click Run workflow manually

   This workflow will create:

   S3 bucket to store Terraform state

   DynamoDB table for state locking

   You must run this first. If you try to run the CI/CD workflow before bootstrap, you will see an error like:

   Error acquiring state lock
   ResourceNotFoundException: Requested resource not found
   Unable to retrieve item from DynamoDB table "terraform-locks"


   This is normal — it means Terraform backend does not exist yet.

Step 2: CI/CD Pipeline (Runs Automatically on Push)

   After bootstrap:

   Every push to the main branch triggers CI/CD pipeline in GitHub Actions.

   Steps performed automatically:

   Checkout code

   Build Java application (Maven)

   Run unit tests

   Build Docker image

   Push Docker image to Docker Hub

   Apply Terraform configuration (main resources: EC2 + Security Group)

   Deploy Docker container to EC2

   You can also trigger this manually via Actions → CI/CD Pipeline → Run workflow.


Step 3: Access the Application

   Once deployment completes:

   Go to the workflow run logs in GitHub Actions

   Find the Terraform apply step output in the CI/CD workflow

   Look for app_url:

   Outputs:
   app_url = http://<EC2_PUBLIC_IP>:8080


   Open this URL in your browser:

   http://<EC2_PUBLIC_IP>:8080


   Expected output:

   Hello from AWS DevOps Assignment!


Tip: After pushing new changes, wait a few seconds for CI/CD to finish and the container to update automatically.

Step 4: Destroy Resources (Manual)

   When finished or to clean up AWS:

   Go to GitHub → Actions → Terraform Destroy

   Click Run workflow

Steps performed:

   Destroys EC2 instance, Security Group, and Docker container

   Deletes S3 bucket and DynamoDB table created during bootstrap

   Note: Terraform cannot destroy the S3 bucket if it contains objects. The destroy workflow handles deleting objects automatically.
   You must run this manually. Resources will not auto-delete after CI/CD runs.


Notes & Tips

Bootstrap: Run once manually before any other workflow.

CI/CD: Runs automatically on main branch push, but can also be triggered manually.

Destroy: Run manually when done to remove all AWS resources.

app_url: Check in GitHub Actions logs in Terraform apply step of CI/CD pipeline.