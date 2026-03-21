output "sqs_queue_url" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.sqs_queue_url
}

output "sqs_queue_arn" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.sqs_queue_arn
}

output "sqs_queue_id" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.sqs_queue_id
}

output "rds_db_instance_endpoint" {
  value       = null
}

output "rds_db_instance_address" {
  value       = null
}

output "rds_db_instance_port" {
  value       = null
}

output "rds_db_name" {
  value       = null
}

output "rds_db_username" {
  value       = null
}

output "redis_cluster_address" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.redis_endpoint
}

output "redis_cluster_port" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.redis_port
}

output "redis_cluster_id" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.redis_cluster_id
}

output "redis_replication_group_primary_endpoint_address" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.redis_replication_group_primary_endpoint_address
}

output "redis_replication_group_reader_endpoint_address" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.redis_replication_group_reader_endpoint_address
}

output "redis_replication_group_id" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.redis_replication_group_id
}

output "redis_subnet_group_name" {
  value       = data.terraform_remote_state.global_infrastructure.outputs.redis_subnet_group_name
}
