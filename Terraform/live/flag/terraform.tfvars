aws_region = "us-east-1"

vpc_id = "vpc-12345678"  # Substitua pelo ID real da VPC

vpc_cidr = "10.0.0.0/16"

private_subnet_ids = ["subnet-12345678", "subnet-87654321"]  # Substitua pelos IDs reais das subnets privadas

project_name  = "flag"
db_identifier = "flag-db"
db_name       = "flagdb"
db_username   = "admin"

tags = {
  Environment = "prd"
  Service     = "flag"
}