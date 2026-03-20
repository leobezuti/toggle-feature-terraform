output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids_list
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
}

output "rds_auth_endpoint" {
  value       = module.rds_auth.db_instance_endpoint
}

output "rds_flag_endpoint" {
  value       = module.rds_flag.db_instance_endpoint
}

output "rds_targeting_endpoint" {
  value       = module.rds_targeting.db_instance_endpoint
}

output "redis_endpoint" {
  value       = module.redis.cluster_address
}

output "dynamodb_table_name" {
  value       = module.dynamodb.table_name
}

output "sqs_queue_url" {
  value       = module.sqs.queue_url
}

output "ecr_repository_urls" {
  value       = module.ecr.repository_urls
}

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions.arn
}
