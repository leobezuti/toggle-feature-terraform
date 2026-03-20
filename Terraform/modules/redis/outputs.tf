# Endpoint do cluster Redis
output "cluster_address" {
  description = "Endereço do cluster Redis"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

# Porta do Redis
output "cluster_port" {
  description = "Porta do cluster Redis"
  value       = aws_elasticache_cluster.redis.port
}

# ID do cluster
output "cluster_id" {
  description = "ID do cluster Redis"
  value       = aws_elasticache_cluster.redis.cluster_id
}

# Endpoint de leitura/escrita do Replication Group
output "replication_group_primary_endpoint_address" {
  description = "Endereço do endpoint primário do replication group"
  value       = try(aws_elasticache_replication_group.redis_ha.primary_endpoint_address, null)
}

# Endpoint de leitura do Replication Group
output "replication_group_reader_endpoint_address" {
  description = "Endereço do endpoint leitor do replication group"
  value       = try(aws_elasticache_replication_group.redis_ha.reader_endpoint_address, null)
}

# ID do Replication Group
output "replication_group_id" {
  description = "ID do replication group"
  value       = try(aws_elasticache_replication_group.redis_ha.id, null)
}

# Subnet Group
output "subnet_group_name" {
  description = "Nome do grupo de subnets"
  value       = aws_elasticache_subnet_group.redis.name
}
