aws_region = "us-east-1"

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