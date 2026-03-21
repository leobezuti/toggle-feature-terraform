# Auth service infrastructure is now managed in global/infrastructure/main.tf
# All shared resources (RDS, VPC, EKS) are consolidated there
# This file is kept for reference only

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "global_infrastructure" {
  backend = "s3"

  config = {
    bucket = "toggle-feature-terraform-state-20"
    key    = "global/infrastructure/terraform.tfstate"
    region = var.aws_region
  }
}
