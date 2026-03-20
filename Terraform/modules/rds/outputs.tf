output "db_instance_endpoint" {
  description = "O endereço de conexão do banco de dados"
  value       = aws_db_instance.postgres.endpoint
}

output "db_instance_address" {
  description = "O hostname do banco de dados (sem a porta)"
  value       = aws_db_instance.postgres.address
}

output "db_instance_port" {
  description = "A porta em que o banco está a escutar"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Nome do database"
  value = aws_db_instance.postgres.db_name
}

output "db_username" {
  description = "Username do database"
  value = aws_db_instance.postgres.username  
}