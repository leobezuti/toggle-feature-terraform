provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "global_vpc" {
  backend = "s3"

  config = {
    bucket = "toggle-feature-terraform-state"
    key    = "global/vpc/terraform.tfstate"
    region = var.aws_region
  }
}

module "auth_service_rds" {
  source = "../../modules/rds"

  project_name       = var.project_name
  vpc_id             = data.terraform_remote_state.global_vpc.outputs.vpc_id
  vpc_cidr           = data.terraform_remote_state.global_vpc.outputs.vpc_cidr_block
  private_subnet_ids = data.terraform_remote_state.global_vpc.outputs.private_subnet_ids_list
  db_identifier      = var.db_identifier
  db_name            = var.db_name
  db_username        = var.db_username
  tags               = var.tags
}
