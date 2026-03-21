terraform {
  backend "s3" {
    bucket       = "toggle-feature-terraform-state-20"
    key          = "auth/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
