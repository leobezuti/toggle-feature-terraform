aws_region = "us-east-1"
project_name = "auth-service-db"
vpc_id = module.global_vpc.vpc_id
vpc_cidr = module.global_vpc.vpc_cidr_block
private_subnet_ids = module.global_vpc.private_subnet_ids_list
db_identifier = "auth-service-db"
db_name = "auth"
db_username = "postgres"