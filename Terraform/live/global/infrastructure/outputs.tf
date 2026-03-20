output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids_list
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "rds_auth_endpoint" {
  description = "Auth RDS endpoint"
  value       = module.rds_auth.db_instance_endpoint
}

output "rds_flag_endpoint" {
  description = "Flag RDS endpoint"
  value       = module.rds_flag.db_instance_endpoint
}

output "rds_targeting_endpoint" {
  description = "Targeting RDS endpoint"
  value       = module.rds_targeting.db_instance_endpoint
}

output "redis_endpoint" {
  description = "Redis cluster endpoint"
  value       = module.redis.cluster_address
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb.table_name
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = module.sqs.queue_url
}

output "ecr_repository_urls" {
  description = "ECR repository URLs"
  value       = module.ecr.repository_urls
}