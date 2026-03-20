aws_region = "us-east-1"

vpc_id = "vpc-12345678"  # Substitua pelo ID real da VPC

vpc_cidr = "10.0.0.0/16"

private_subnet_ids = ["subnet-12345678", "subnet-87654321"]  # Substitua pelos IDs reais das subnets privadas

project_name  = "targeting"
db_identifier = "targeting-db"
db_name       = "targetingdb"
db_username   = "admin"

tags = {
  Environment = "prd"
  Service     = "targeting"
}