output "table_name" {
  description = "Nome da tabela DynamoDB"
  value       = module.analytics_service_dynamodb.table_name
}

output "table_arn" {
  description = "ARN da tabela DynamoDB"
  value       = module.analytics_service_dynamodb.table_arn
}

output "table_id" {
  description = "ID da tabela DynamoDB"
  value       = module.analytics_service_dynamodb.table_id
}

output "stream_arn" {
  description = "ARN do stream da tabela"
  value       = module.analytics_service_dynamodb.stream_arn
}

output "stream_specification" {
  description = "Especificação do stream"
  value       = module.analytics_service_dynamodb.stream_specification
}

output "global_secondary_indexes" {
  description = "Lista de índices secundários globais"
  value       = module.analytics_service_dynamodb.global_secondary_indexes
}

output "billing_mode" {
  description = "Modo de cobrança da tabela"
  value       = module.analytics_service_dynamodb.billing_mode
}