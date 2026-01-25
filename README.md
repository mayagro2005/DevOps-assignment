# 🟢 Java DevOps Assignment (OIDC Edition)

This project demonstrates a **full DevOps workflow**:

- CI/CD with **GitHub Actions**  
- **Docker** containerization  
- **AWS** infrastructure provisioning with **Terraform**  
- Automatic deployment to **EC2**  

The application runs on **port 8080** and updates automatically whenever code is pushed to GitHub.

---

## 📌 Prerequisites

You only need **Git** installed locally.  

> **No need** to install Docker, Terraform, or AWS CLI — everything is handled by GitHub Actions.

**Secrets are already configured in this GitHub repository:**

- `DOCKERHUB_USERNAME`  
- `DOCKERHUB_TOKEN`  

> AWS credentials are now obtained automatically via **GitHub OIDC**. No AWS keys are stored in the repo.

---

## 1️⃣ Bootstrap Terraform Backend (Manual, Only Once)

Before the first deployment, you **must create the Terraform backend**:

1. Go to **GitHub → Actions → Terraform Bootstrap**  
2. Click **Run workflow manually**  

This workflow will create:  

- **S3 bucket** to store Terraform state  
- **DynamoDB table** for state locking  

> **Important:** You must run this first.  
> If you try to run the CI/CD workflow before bootstrap, you will see an error like:

Backend S3 bucket does not exist! Run bootstrap workflow first.

This is normal — it means the Terraform backend does not exist yet.

---

## 2️⃣ CI/CD Pipeline (Runs Automatically on Push)

After bootstrap is complete:  

- Every push to the **`main` branch** triggers the CI/CD pipeline in GitHub Actions.  

**Pipeline steps (automatic):**

1. Checkout code  
2. Build Java application (Maven)  
3. Run unit tests  
4. Build Docker image  
5. Push Docker image to Docker Hub  
6. Apply Terraform configuration (**main resources:** EC2 + Security Group)  
7. Deploy Docker container to EC2  

> You can also **trigger this manually** via:  
> `Actions → CI/CD Pipeline → Run workflow`

**Note:** This workflow uses **GitHub OIDC** to assume the IAM role — no AWS keys are needed. Any collaborator with push access can run it safely.

---

## 3️⃣ Access the Application

Once deployment is complete:  

1. Go to **GitHub Actions → CI/CD pipeline run logs**  
2. Find the **Terraform Apply** step output  
3. Look for `app_url`:

Outputs:
app_url = http://<EC2_PUBLIC_IP>:8080

4. Open this URL in your browser:  

http://<EC2_PUBLIC_IP>:8080

**Expected output:**

Hello from AWS DevOps Assignment!


> **Tip:** After pushing new changes, wait a few seconds for CI/CD to finish and the container to update automatically.

---

## 4️⃣ Destroy Resources (Manual)

When finished or to clean up AWS:  

1. Go to **GitHub → Actions → Terraform Destroy**  
2. Click **Run workflow**  

**Steps performed:**

- Destroys EC2 instance, Security Group, and Docker container  
- Deletes S3 bucket and DynamoDB table created during bootstrap  

> **Note:** Terraform cannot destroy an S3 bucket if it contains objects. The destroy workflow handles deleting objects automatically.  
> You **must run this manually** — resources will **not** auto-delete after CI/CD runs.

---

## 📝 Notes & Tips

- **Bootstrap:** Run **once manually** before any other workflow  
- **CI/CD:** Runs automatically on `main` branch push, but can also be triggered manually  
- **Destroy:** Run manually when done to remove all AWS resources  
- **OIDC:** All workflows now use **temporary AWS credentials**; no static secrets needed  
- **app_url:** Check in **GitHub Actions logs → Terraform apply step** of the CI/CD pipeline  
- **Repo sharing:** Anyone with push access can safely trigger the workflows; AWS credentials are temporary and bound to this repo