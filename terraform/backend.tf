terraform {
  backend "s3" {
    bucket         = "maya-terraform-state-123456"
    key            = "env/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
