provider "aws" {
  region = var.aws_region
}

module "auth_service_rds" {
  source = "../modules/rds"

  project_name       = var.project_name
  vpc_id             = var.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = var.private_subnet_ids
  db_identifier      = var.db_identifier
  db_name            = var.db_name
  db_username        = var.db_username
}
