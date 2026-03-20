resource "aws_elasticache_subnet_group" "redis" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.cluster_name}-subnet-group" })
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_name
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = var.parameter_group_name
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.redis.name

  tags = merge(var.tags, { Name = var.cluster_name })
}
