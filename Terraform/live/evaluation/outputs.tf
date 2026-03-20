output "sqs_queue_url" {
  value       = module.evaluation_service_sqs.queue_url
}

output "sqs_queue_arn" {
  value       = module.evaluation_service_sqs.queue_arn
}

output "sqs_queue_id" {
  value       = module.evaluation_service_sqs.queue_id
}

output "rds_db_instance_endpoint" {
  value       = module.evaluation_service_rds.db_instance_endpoint
}

output "rds_db_instance_address" {
  value       = module.evaluation_service_rds.db_instance_address
}

output "rds_db_instance_port" {
  value       = module.evaluation_service_rds.db_instance_port
}

output "rds_db_name" {
  value       = module.evaluation_service_rds.db_name
}

output "rds_db_username" {
  value       = module.evaluation_service_rds.db_username
}

output "redis_cluster_address" {
  value       = module.evaluation_service_redis.cluster_address
}

output "redis_cluster_port" {
  value       = module.evaluation_service_redis.cluster_port
}

output "redis_cluster_id" {
  value       = module.evaluation_service_redis.cluster_id
}

output "redis_replication_group_primary_endpoint_address" {
  value       = module.evaluation_service_redis.replication_group_primary_endpoint_address
}

output "redis_replication_group_reader_endpoint_address" {
  value       = module.evaluation_service_redis.replication_group_reader_endpoint_address
}

output "redis_replication_group_id" {
  value       = module.evaluation_service_redis.replication_group_id
}

output "redis_subnet_group_name" {
  value       = module.evaluation_service_redis.subnet_group_name
}
