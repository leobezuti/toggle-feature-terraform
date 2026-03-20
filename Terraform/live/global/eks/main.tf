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

module "eks_cluster" {
  source = "../../../modules/eks"

  cluster_name                  = var.cluster_name
  subnet_ids                    = data.terraform_remote_state.global_vpc.outputs.private_subnet_ids_list
  enable_elastic_load_balancing = var.enable_elastic_load_balancing
  node_group_name               = var.node_group_name
  instance_type                 = var.instance_type
  desired_size                  = var.desired_size
  min_size                      = var.min_size
  max_size                      = var.max_size
  tags                          = var.tags
}
