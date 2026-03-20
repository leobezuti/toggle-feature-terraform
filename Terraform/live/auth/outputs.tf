output "db_instance_endpoint" {
  description = "O endereço de conexão do banco de dados"
  value       = module.auth_service_rds.db_instance_endpoint
}

output "db_instance_address" {
  description = "O hostname do banco de dados (sem a porta)"
  value       = module.auth_service_rds.db_instance_address
}

output "db_instance_port" {
  description = "A porta em que o banco está a escutar"
  value       = module.auth_service_rds.db_instance_port
}

output "db_name" {
  description = "Nome do database"
  value       = module.auth_service_rds.db_name
}

output "db_username" {
  description = "Username do database"
  value       = module.auth_service_rds.db_username
}