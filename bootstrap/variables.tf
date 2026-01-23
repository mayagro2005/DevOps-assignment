variable "aws_region" {
  default = "eu-central-1"
}

variable "state_bucket" {
  default = "maya-terraform-state-123456"
}

variable "lock_table" {
  default = "terraform-locks"
}
