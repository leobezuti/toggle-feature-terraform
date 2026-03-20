aws_region = "us-east-1"

vpc_id = "vpc-12345678"  # Substitua pelo ID real da VPC

vpc_cidr = "10.0.0.0/16"

private_subnet_ids = ["subnet-12345678", "subnet-87654321"]  # Substitua pelos IDs reais das subnets privadas

tags = {
  Environment = "prd"
  Service     = "evaluation"
}

# SQS
queue_name = "evaluation-queue"

# RDS
project_name  = "evaluation"
db_identifier = "evaluation-db"
db_name       = "evaluationdb"
db_username   = "admin"

# Redis
cluster_name         = "evaluation-redis"
replication_group_id = "evaluation-redis-rg"