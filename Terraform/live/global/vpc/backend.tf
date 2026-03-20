terraform {
  backend "s3" {
    bucket         = "toggle-feature-terraform-state"
    key            = "global/vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}