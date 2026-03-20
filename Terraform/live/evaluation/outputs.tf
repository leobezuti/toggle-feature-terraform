# SQS outputs
output "sqs_queue_url" {
  description = "URL da fila SQS"
  value       = module.sqs.queue_url
}

output "sqs_queue_arn" {
  description = "ARN da fila SQS"
  value       = module.sqs.queue_arn
}

output "sqs_queue_id" {
  description = "ID da fila SQS"
  value       = module.sqs.queue_id
}

# RDS outputs
output "rds_db_instance_endpoint" {
  description = "O endereço de conexão do banco de dados"
  value       = module.rds.db_instance_endpoint
}

output "rds_db_instance_address" {
  description = "O hostname do banco de dados (sem a porta)"
  value       = module.rds.db_instance_address
}

output "rds_db_instance_port" {
  description = "A porta em que o banco está a escutar"
  value       = module.rds.db_instance_port
}

output "rds_db_name" {
  description = "Nome do database"
  value       = module.rds.db_name
}

output "rds_db_username" {
  description = "Username do database"
  value       = module.rds.db_username
}

# Redis outputs
output "redis_cluster_address" {
  description = "Endereço do cluster Redis"
  value       = module.redis.cluster_address
}

output "redis_cluster_port" {
  description = "Porta do cluster Redis"
  value       = module.redis.cluster_port
}

output "redis_cluster_id" {
  description = "ID do cluster Redis"
  value       = module.redis.cluster_id
}

output "redis_replication_group_primary_endpoint_address" {
  description = "Endereço do endpoint primário do replication group"
  value       = module.redis.replication_group_primary_endpoint_address
}

output "redis_replication_group_reader_endpoint_address" {
  description = "Endereço do endpoint leitor do replication group"
  value       = module.redis.replication_group_reader_endpoint_address
}

output "redis_replication_group_id" {
  description = "ID do replication group"
  value       = module.redis.replication_group_id
}

output "redis_subnet_group_name" {
  description = "Nome do grupo de subnets"
  value       = module.redis.subnet_group_name
}