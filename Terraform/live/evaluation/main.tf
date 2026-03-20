provider "aws" {
  region = var.aws_region
}

module "evaluation_service_sqs" {
  source = "../../modules/sqs"

  queue_name                   = var.queue_name
  delay_seconds                = var.delay_seconds
  max_message_size             = var.max_message_size
  message_retention_seconds    = var.message_retention_seconds
  visibility_timeout_seconds   = var.visibility_timeout_seconds
  receive_wait_time_seconds    = var.receive_wait_time_seconds
  tags                         = var.tags
}

module "evaluation_service_rds" {
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

module "evaluation_service_redis" {
  source = "../../modules/redis"

  cluster_name            = var.cluster_name
  elasticache_description = var.elasticache_description
  replication_group_id    = var.replication_group_id
  engine                  = var.engine
  node_type               = var.node_type
  num_cache_nodes         = var.num_cache_nodes
  parameter_group_name    = var.parameter_group_name
  engine_version          = var.engine_version
  port                    = var.port
  subnet_group_name = ""
  security_group_ids = []
}