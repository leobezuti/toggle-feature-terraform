provider "aws" {
  region = var.aws_region
}

module "targeting_service_rds" {
  source = "../../modules/rds"

  project_name       = var.project_name
  vpc_id             = var.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = var.private_subnet_ids
  db_identifier      = var.db_identifier
  db_name            = var.db_name
  db_username        = var.db_username
  db_engine_version  = var.db_engine_version
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  tags               = var.tags
}