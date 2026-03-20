provider "aws" {
  region = var.aws_region
}

module "analytics_service_dynamodb" {
  source = "../../modules/dynamodb"

  table_name                     = var.table_name
  hash_key                       = var.hash_key
  hash_key_type                  = var.hash_key_type
  billing_mode                   = var.billing_mode
  read_capacity                  = var.read_capacity
  write_capacity                 = var.write_capacity
  ttl_attribute_name             = var.ttl_attribute_name
  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
  tags                           = var.tags
}