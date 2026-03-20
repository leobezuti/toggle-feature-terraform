output "db_instance_endpoint" {
  value       = module.auth_service_rds.db_instance_endpoint
}

output "db_instance_address" {
  value       = module.auth_service_rds.db_instance_address
}

output "db_instance_port" {
  value       = module.auth_service_rds.db_instance_port
}

output "db_name" {
  value       = module.auth_service_rds.db_name
}

output "db_username" {
  value       = module.auth_service_rds.db_username
}
